
# This is config file for spilot
GLOBIGNORE="*"
# output formatting
SHELLPILOT_CYAN_LABEL="\033[94m<<ShellPilot>> \033[0m"
PROCESSING_LABEL="\n\033[92m  Processing... \033[0m\033[0K\r"
OVERWRITE_PROCESSING_LINE="             \033[0K\r"
COLUMNS=$(tput cols)

# Configuration settings
USE_API=ollama
CURRENT_DATE=$(date +%m/%d/%Y)

# Set default values for OpenAI settings
if [ "$USE_API" == "ollama" ]; then
    MODEL_NAME="Ollama"
    ORGANIZATION="Ollama"
fi

# Adjust settings for Ollama API
if [ "$USE_API" == "openai" ]; then
    MODEL_NAME="ChatGPT"
    ORGANIZATION="OpenAI"
fi

# Define prompts using the adjusted settings
CHAT_INIT_PROMPT="You are $MODEL_NAME, a Large Language Model trained by $ORGANIZATION. You will be answering questions from users. Answer as concisely as possible for each response. Keep the number of items short. Output your answer directly, with no labels in front. Do not start your answers with 'A' or 'Answer'. You were trained on data up until 2023. Today's date is $CURRENT_DATE"
SYSTEM_PROMPT="You are $MODEL_NAME, a large language model trained by $ORGANIZATION. Answer as concisely as possible. Current date: $CURRENT_DATE. Knowledge cutoff: 9/1/2023."
COMMAND_GENERATION_PROMPT="You are a Command Line Interface expert and your task is to provide functioning shell commands. Return a CLI command and nothing else - do not send it in a code block, quotes, or anything else, just the pure text CONTAINING ONLY THE COMMAND. If possible, return a one-line bash command or chain many commands together. Return ONLY the command ready to run in the terminal. The command should do the following:"

# chat settings
TEMPERATURE=0.9
MAX_TOKENS=4096
MODEL_OPENAI=gpt-3.5-turbo
MODEL_OLLAMA=llama2
CONTEXT=false
MULTI_LINE_PROMPT=false
ENABLE_DANGER_FLAG=false

