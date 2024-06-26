set -x 

read -r -d '' training_commands <<EOF
../train_dpo.py \
     --save_path ./ckpt/7b_llama \
     --save_steps -1 \
     --logging_steps 1 \
     --eval_steps -1 \
     --train_batch_size 128 \
     --micro_train_batch_size 1 \
     --pretrain OpenLLMAI/Llama-2-13b-sft-model-ocra-500k \
     --bf16 \
     --max_epochs 1 \
     --max_len 2048 \
     --zero_stage 2 \
     --simpo \
     --learning_rate 5e-7 \
     --dataset Anthropic/hh-rlhf,tasksource/oasst1_pairwise_rlhf_reward,lmsys/chatbot_arena_conversations,openai/webgpt_comparisons \
     --dataset_probs 0.72,0.08,0.12,0.08 \
     --flash_attn \
     --gradient_checkpointing \
EOF
     # --wandb [WANDB_TOKENS] or True (use wandb login command)
     # --ipo [for IPO]
     # --label_smoothing 0.1 [for cDPO]


if [[ ${1} != "slurm" ]]; then
    deepspeed $training_commands
fi
