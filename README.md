<h1>shell-pilot</h1>

A version of the [chatGPT-shell-cli](https://github.com/0xacx/chatGPT-shell-cli) library , modified to support `Ollama` and work with local LLM, and improve some features.

A simple, lightweight shell script to use `OpenAI(chatGPT and DALL-E)` or `Ollama` from the terminal without installing python or node.js. The script uses the official ChatGPT model `gpt-3.5-turbo` with the OpenAI API endpoint `/chat/completions`. You can also use the new `gpt-4` model, if you have access.  
Also, support with local LLm from `ollma`.
</div>

## Features

- Based on [Ollama](https://ollama.com/) to setup a local LLM repository, work with [Ollama API](https://github.com/ollama/ollama/blob/main/docs/api.md)
- Use the official chatgpt model with the ✨ [official ChatGPT API](https://openai.com/blog/introducing-chatgpt-and-whisper-apis) ✨ from the terminal
- View your history
- Chat context, GPT remembers previous chat questions and answers
- Pass the input prompt with, as a script parameter or normal chat mode
- List all available models 
- Set OpenAI request parameters
- Generate a command and run it in terminal
- Easy to set the config

## Getting Started

### Prerequisites

This script relies on curl for the requests to the api and jq to parse the json response.

* [curl](https://www.curl.se)
  ```sh
  MacOS:
  brew install curl

  Linux: should be installed by default
  dnf/yum/apt install curl
  ```
* [jq](https://stedolan.github.io/jq/)
  ```sh
  MacOS:
  brew install jq

  Linux: should be installed by default
  dnf/yum/apt install jq
  ```
* An OpenAI API key. Create an account and get a free API Key at [OpenAI](https://beta.openai.com/account/api-keys)

* Optionally, you can install [glow](https://github.com/charmbracelet/glow) to render responses in markdown 

### Installation

   Setup `Ollama` environment, [Manual install instructions](https://github.com/ollama/ollama/blob/main/docs/linux.md), [ollama usage](https://github.com/ollama/ollama), and [Ollama model library](https://ollama.com/library)
   ```sh
   curl -fsSL https://ollama.com/install.sh | sh

   ollama pull llama2  # used llama2 by default
   ```

   To install, run this in your terminal and provide your OpenAI API key when asked.
   
   ```sh
   curl -sS https://raw.githubusercontent.com/reid41/shell-pilot/main/spilot_install.sh | sudo -E bash
   ```

   Set your local `Ollama` server ip in configuration file `spilot_common.sh` if not set during the installation
   ```sh
   OLLAMA_SERVER_IP=<ollama server ip address>
   ```

   You can also set the other parameters in `spilot_common.sh` before using.
   ```sh
   e.g.
   TEMPERATURE=0.6
   MAX_TOKENS=4096
   MODEL_OPENAI=gpt-3.5-turbo
   MODEL_OLLAMA=llama2
   CONTEXT=false
   MULTI_LINE_PROMPT=false
   ENABLE_DANGER_FLAG=false
   ```

### Manual Installation

  If you want to install it manually, all you have to do is:

  - Download the `s-pilot` file in a directory you want
  - Add the path of `s-pilot` to your `$PATH`. You do that by adding this line to your shell profile: `export PATH=$PATH:/path/to/s-pilot`
  - Reset the `SHELL_PILOT_CONFIG_PATH` in `s-pilot` if the `spilot_common.sh` path changed
  - Add the OpenAI API key to your shell profile by adding this line `export OPENAI_KEY=your_key_here`
  - Add Ollama server ip address in `spilot_common.sh` for `OLLAMA_SERVER_IP` variable

## Usage

### Start

#### Chat Mode
  - Run the script by using the `s-pilot` command anywhere:
  ```shell
  $ s-pilot
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.

  <<You>>
  ```

#### Pipe Mode
  - You can also use it in pipe mode:
  ```shell
  $ echo "How to view running processes on RHEL8?" | s-pilot

  You can view running processes on RHEL8 using the `ps` command. To see a list of running processes,
  open a terminal and type `ps aux` or `ps -ef`. This will display a list of all processes currently
  running on your system.


  $ cat error.log | s-pilot

  The log entries indicate the following events on the system:

  1. April 7, 23:35:40: Log rotation initiated by systemd, then completed successfully.
  2. April 8, 05:20:51: Error encountered during metadata download for repository
  ```

#### Script Parameters
  - Help with `h`, `-h`, `--help`:

  -  Chat mode with initial prompt:
  ```shell
  s-pilot ip "You are Linux Master. You should provide a detail and professional suggeston about Linux every time."
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.

  <<You>>
  what is shell?


  <<ShellPilot>> A shell is a command-line interface that allows users to interact with the
  operating system by running commands. It is a program that takes input from the user in the form of
  commands and then executes them. The shell acts as an intermediary between the user and the
  operating system, interpreting commands and running programs. There are different types of shells
  available in Linux, such as bash (Bourne Again Shell), sh (Bourne Shell), csh (C Shell), ksh (Korn
  Shell), and more. Each shell has its own set of features and capabilities, but they all serve the
  same fundamental purpose of allowing users to interact with the system via the command line.
  ```

  - with `p`:
  ```shell
  s-pilot -p "What is the regex to match an ip address?"

  The regex to match an IP address is:
  (?:\d{1,3}\.){3}\d{1,3}


  $ cat error.log | s-pilot p "find the errors and provide solution"

  Errors:
  1. Inconsistent date formats: "Apr 7" and "Apr 8".
  2. Inconsistency in log times: "23:35:40" and "10:03:28" for the same date.

  Solutions:
  1. Standardize date format: Use a consistent date format throughout the log entries.
  2. Ensure log times are in chronological order within the same date.
  ```

  - change model provider:
  ```shell

  s-pilot cmp ollama
  Attempting to update USE_API to ollama.
  Backup file removed after successful update.
  The setting will save in the configuration file.

  Here is the checklist to change the model provider:
  USE_API=ollama
  ```

  - list models:
  ```shell
  s-pilot lm

  {
    "name": "llama2:13b",
    "size": "6.86 GB",
    "format": "gguf",
    "parameter_size": "13B",
    "quantization_level": "Q4_0"
  }
  ```

  - list config
  ```shell
  s-pilot lc
  # Configuration settings
  USE_API=ollama

  # Define prompts using the adjusted settings
  CHAT_INIT_PROMPT="You are $MODEL_NAME, a Large Language Model trained by $ORGANIZATION. You will be answering questions from users. Answer as concisely as possible for each response.
  ...
  ```

  - Update the chat setting in `spilot_common.sh`
  ```shell
  s-pilot t 0.9
  Attempting to update TEMPERATURE to 0.9.
  Backup file removed after successful update.
  The setting will save in the configuration file.

  Here is the checklist to change the temperature:
  TEMPERATURE=0.9
  ```

### Commands

  - `history` To view your chat history, type `history`
  ```shell
  $ s-pilot
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.

  <<You>>
  history

  2024-04-08 18:51 hi
  Hello! How can I assist you today?
  ```

  - `models` To get a list of the models available at OpenAI API/Ollama, type `models`
  ```shell
  $ s-pilot
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.
  <<You>>
  models
  {
    "name": "llama2:13b",
    "size": "6.86 GB",
    "format": "gguf",
    "parameter_size": "13B",
    "quantization_level": "Q4_0"
  }
  ```

  - `model:` To view all the information on a specific model, start a prompt with `model:` and the model `id`,e.g.
  ``` shell
  $ s-pilot
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.

  <<You>>
  model:llama2

  License: LLAMA 2 COMMUNITY LICENSE AGREEMENT
  Llama 2 Version Release Date: July 18, 2023
  ...
  Format: gguf
  Family: llama
  Parameter Size: 7B
  Quantization Level: Q4_0
  ```

  - `cmd:` To get a command with the specified functionality and run it, just type `cmd:` and explain what you want to achieve. The script will always ask you if you want to execute the command. i.e.
  *If a command modifies your file system or dowloads external files the script will show a warning before executing, but if the execution flag is disabled by default if found danger.*
  ```shell
  s-pilot
  Welcome to Shell Pilot!!
  You can quit with 'q' or 'e'.

  <<You>>
  cmd: list the files in /tmp/


  <<ShellPilot>>  ls /tmp
  Would you like to execute it? (Yes/No)
  y

  Executing command: ls /tmp

  com.xx.launchd.xx	com.x.xx		com.xx.out
  com.xx.launchd.xx	com.x.err			powerlog


  # The danger cmd example:
  <<You>>
  cmd: remove the files in /tmp/


  <<ShellPilot>>  rm -r /tmp/*
  Warning: This command can change your file system or download external scripts & data.
  Please do not execute code that you don't understand completely.

  Info: Execution of potentially dangerous commands has been disabled.
  ```

### Chat context

  - For models other than `gpt-3.5-turbo` and `gpt-4` where the chat context is not supported by the OpenAI api, you can use the chat context build in this script. You can enable chat context mode for the model to remember your previous chat questions and answers. This way you can ask follow-up questions. In chat context the model gets a prompt to act as ChatGPT and is aware of today's date and that it's trained with data up until 2021. To enable this mode start the script with  `c`, `-c` or `--chat-context`. i.e. `s-pilot c true` to enable it. 

#### Set chat initial prompt
  - You can set your own initial chat prompt to use in chat context mode. The initial prompt will be sent on every request along with your regular prompt so that the OpenAI model will "stay in character". To set your own custom initial chat prompt use `ip` `-ip` or `--init-prompt` followed by your initial prompt i.e. see the `Script Parameters` usage example.
  - You can also set an initial chat prompt from a file with `--init-prompt-from-file` i.e. `s-pilot --init-prompt-from-file myprompt.txt`
  
  *When you set an initial prompt you don't need to enable the chat context. 

### Use the official  model

  - The default model used when starting the script is `gpt-3.5-turbo` for OpenAI.
  
  - The default model used when starting the script is `llama2` for Ollama.
  
### Use other models for OpenAI or Ollama
  - If you have access to the GPT4 model you can use it by setting the model to `gpt-4`, i.e. `s-pilot --model gpt-4`.

  - For `Ollama`, you can pull first from the ollama server, i.e. `ollama pull mistral`.

### Set request parameters

  - To set request parameters you can start the script like this: `s-pilot t 0.9`.
  - The setting will save in `spilot_common.sh`, no need to change or mention every time.
  
    The available parameters are: 
      - temperature, `t` or  `-t` or `--temperature`
      - model, `m` or `-m` or `--model`
      - max number of tokens,`mt`, `-mt`, `--max-tokens`
      - prompt, `p`, `-p` or `--prompt` 
      - prompt from a file in your file system, `pf` or `-pf` or `--prompt-from-file`  
      
    For OpenAI: [OpenAI API documentation](https://platform.openai.com/docs/api-reference/completions/create)
    For Ollama: [Ollama API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)