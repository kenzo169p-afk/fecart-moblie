"""
Olhar das Máquinas - Servidor Web Local para Alta Compatibilidade de Câmeras
Garante que o painel web index.html execute sob uma Origem Segura (http://localhost:8000),
permitindo que navegadores modernos (Chrome, Edge, Firefox) concedam 100% de acesso às webcams.
"""

import http.server
import socketserver
import webbrowser
import os
import sys
import socket

# Garante que o diretório de execução seja a pasta do script
DIRETORIO_PROJETO = os.path.dirname(os.path.abspath(__file__))
os.chdir(DIRETORIO_PROJETO)

PORTA_INICIAL = 8000
PORTA_MAXIMA = 8050

def obter_ip_rede():
    """Detecta o IP local da máquina na rede Wi-Fi/Ethernet para acesso via celular ou tablet."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
            s.connect(('8.8.8.8', 80))
            return s.getsockname()[0]
    except Exception:
        try:
            return socket.gethostbyname(socket.gethostname())
        except Exception:
            return '127.0.0.1'

def encontrar_porta_livre(porta_inicio=8000, porta_fim=8050):
    for p in range(porta_inicio, porta_fim):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            try:
                s.bind(('0.0.0.0', p))
                return p
            except OSError:
                continue
    return porta_inicio

class RequisicoesPersonalizadas(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Habilita cabeçalhos CORS e desativa cache agressivo para desenvolvimento
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        super().end_headers()

    def log_message(self, format, *args):
        # Exibe logs de requisições de forma limpa no console
        sys.stdout.write(f"[HTTP] {self.address_string()} - {format % args}\n")
        sys.stdout.flush()

def main():
    porta = encontrar_porta_livre(PORTA_INICIAL, PORTA_MAXIMA)
    ip_rede = obter_ip_rede()
    url_local = f"http://localhost:{porta}/index.html"
    url_mobile = f"http://{ip_rede}:{porta}/index.html"

    print("=" * 70)
    print("      OLHAR DAS MÁQUINAS - SERVIDOR WEB (PC & CELULARES / TABLETS)")
    print("=" * 70)
    print(f"Diretório raiz : {DIRETORIO_PROJETO}")
    print(f"Acesso no PC   : {url_local}")
    print(f"Acesso Mobile  : {url_mobile}  (Celular / Tablet no mesmo Wi-Fi)")
    print("=" * 70)
    print("[1] PC Desktop : 2 Câmeras USB simultâneas com anti-duplicação.")
    print("[2] Celular    : 1 Câmera nativa com alternância rápida (Frontal/Traseira).")
    print("[3] Abrindo automaticamente o navegador no PC...")
    print("[4] Para encerrar o servidor, pressione Ctrl + C no terminal.")
    print("=" * 70)

    try:
        webbrowser.open(url_local)
    except Exception as e:
        print(f"Aviso ao abrir navegador: {e}")

    socketserver.TCPServer.allow_reuse_address = True
    try:
        with socketserver.TCPServer(("0.0.0.0", porta), RequisicoesPersonalizadas) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n\nServidor local encerrado com sucesso.")
    except Exception as e:
        print(f"\nErro no servidor: {e}")

if __name__ == "__main__":
    main()
