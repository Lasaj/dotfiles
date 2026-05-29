import socket
import sys
import os
import re

# Get real signature
real_sig = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
if not real_sig:
    try:
        dirs = [d for d in os.listdir("/run/user/1000/hypr") if len(d) > 30 and d != "waybar_proxy"]
        if dirs:
            real_sig = dirs[0]
    except Exception:
        pass

if not real_sig:
    print("HYPRLAND_INSTANCE_SIGNATURE is not set and could not be detected!")
    sys.exit(1)

# Check real socket exists
real_socket_path = f"/run/user/1000/hypr/{real_sig}/.socket.sock"
if not os.path.exists(real_socket_path):
    print(f"Real socket does not exist: {real_socket_path}")
    sys.exit(1)

proxy_dir = "/run/user/1000/hypr/waybar_proxy"
os.makedirs(proxy_dir, exist_ok=True)

# Symlink .socket2.sock
proxy_socket2 = f"{proxy_dir}/.socket2.sock"
if os.path.exists(proxy_socket2) or os.path.islink(proxy_socket2):
    os.remove(proxy_socket2)
os.symlink(f"/run/user/1000/hypr/{real_sig}/.socket2.sock", proxy_socket2)

# Bind proxy .socket.sock
proxy_socket = f"{proxy_dir}/.socket.sock"
if os.path.exists(proxy_socket):
    os.remove(proxy_socket)

server = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
server.bind(proxy_socket)
server.listen(50)

print(f"Proxy listening on {proxy_socket} -> {real_socket_path}")

try:
    while True:
        client_sock, _ = server.accept()
        data = client_sock.recv(4096)
        if not data:
            client_sock.close()
            continue
        
        print(f"--- Incoming connection ---")
        print(f"Raw received: {repr(data)}")
        
        cmd = data.decode('utf-8', errors='ignore').strip()
        print(f"Decoded command: {repr(cmd)}")
        
        # Match both "dispatch workspace X" and "dispatch focusworkspaceoncurrentmonitor X"
        match = re.match(r"^dispatch\s+(workspace|focusworkspaceoncurrentmonitor)\s+(.+)$", cmd)
        if match:
            target = match.group(2)
            # Rewrite to Lua dispatcher syntax
            new_cmd = f"dispatch hl.dsp.focus({{ workspace = {repr(target)} }})\n"
            print(f"Rewriting to: {repr(new_cmd)}")
            data = new_cmd.encode('utf-8')
        else:
            # Ensure we preserve the exact original data, but make sure it ends with newline if text
            # Some queries might end with \0 or newline. We should preserve them if possible.
            pass

        try:
            real_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            real_sock.connect(real_socket_path)
            real_sock.sendall(data)
            print(f"Sent to Hyprland: {repr(data)}")
            
            # Read complete response until EOF
            resp = b""
            while True:
                chunk = real_sock.recv(4096)
                if not chunk:
                    break
                resp += chunk
                
            real_sock.close()
            print(f"Response length: {len(resp)}")
            print(f"Response preview: {repr(resp[:200])}")
            client_sock.sendall(resp)
        except Exception as e:
            print(f"Error forwarding: {e}")
            client_sock.sendall(b"error: forward failed\n")
        
        client_sock.close()
except KeyboardInterrupt:
    pass
finally:
    server.close()
    if os.path.exists(proxy_socket):
        os.remove(proxy_socket)
    if os.path.exists(proxy_socket2) or os.path.islink(proxy_socket2):
        os.remove(proxy_socket2)
