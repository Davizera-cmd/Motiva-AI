# Motiva-AI - Guia de Inicialização

Guia prático para configurar e rodar o projeto localmente com o celular conectado via cabo USB.

---

## Passo 1: Executar o Backend (Node.js)

O backend realiza a ponte segura com os provedores de inteligência artificial para que as chaves de API não fiquem expostas no aplicativo.

1. Acesse o diretório da API:
   ```bash
   cd motiva-ai_api
   ```
2. Instale as dependências:
   ```bash
   npm install
   ```
3. Configure as variáveis de ambiente:
   Crie um arquivo `.env` na raiz da pasta `motiva-ai_api` e configure suas credenciais de IA:
   ```env
   PORT=3000
   NODE_ENV=development
   USE_GEMINI=true

   GEMINI_API_KEY=sua-chave-do-google-ai-studio
   GEMINI_MODEL=gemini-1.5-flash

   OPENROUTER_API_KEY=sua-chave-do-openrouter
   OPENROUTER_MODEL=google/gemma-4-26b-a4b-it:free
   ```
4. Inicie o servidor:
   ```bash
   node src/server.js
   ```

---

## Passo 2: Preparar o Celular (Modo Desenvolvedor)

O aplicativo precisa ser executado em um celular Android físico conectado ao computador.

1. No seu celular Android, abra as **Configurações > Sobre o telefone**.
2. Toque em **Número da versão** (ou número de compilação) **7 vezes** até aparecer a mensagem de que você é um desenvolvedor.
3. Volte ao menu principal de configurações, entre em **Opções do desenvolvedor** e ative a **Depuração USB**.
4. Conecte o celular ao computador usando um cabo USB de boa qualidade.

---

## Passo 3: Espelhar o Celular e Redirecionar as Portas (Scrcpy + ADB)

Como o servidor Node.js está rodando localmente no computador, precisamos direcionar a porta `3000` via USB para que o aplicativo instalado no celular consiga se conectar à nossa API.

1. Baixe o [Scrcpy](https://scrcpy.org/download/) e extraia os arquivos em uma pasta no seu computador.
2. Abra um terminal dentro da pasta extraída do Scrcpy.
3. Execute o comando a seguir com o prefixo `.\` (se não der, tenta sem o prefixo) para mapear a rede via USB:
   ```powershell
   .\adb.exe reverse tcp:3000 tcp:3000
   ```
4. Para espelhar a tela do celular no computador (ideal para apresentações ou testes visuais rápidos), basta executar o scrcpy:
   ```powershell
   .\scrcpy.exe
   ```

---

## Passo 4: Executar o Aplicativo (Flutter)

Com o backend ativo e o túnel USB configurado pelo ADB:

1. Abra um terminal na pasta do aplicativo:
   ```bash
   cd motiva-ai_app
   ```
2. Baixe os pacotes do Flutter:
   ```bash
   flutter pub get
   ```
3. Execute o aplicativo no seu dispositivo físico conectado:
   ```bash
   flutter run
   ```

---

## Resumo do Fluxo de Trabalho (O que deve ficar rodando)

Para testar o aplicativo e as notificações inteligentes, você manterá **três terminais abertos**:

1. **Terminal do Backend (`motiva-ai_api`)**: Rodando o servidor local na porta 3000 (`node src/server.js`).
2. **Terminal do Scrcpy**: Com o comando `.\adb.exe reverse tcp:3000 tcp:3000` executado com sucesso e o celular espelhado via `.\scrcpy.exe`.
3. **Terminal do App (`motiva-ai_app`)**: Rodando a compilação e monitorando o aplicativo em tempo real (`flutter run`).

### Como testar as mensagens de IA:
No aplicativo rodando no celular, vá até a aba de **Ajustes** (Configurações) e clique em **"Testar Notificação Agora"**. Uma chamada será feita para a API local via USB e o seu celular receberá a notificação completa gerada pela IA na hora!
