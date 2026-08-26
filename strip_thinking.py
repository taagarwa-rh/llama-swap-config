from litellm.integrations.custom_logger import CustomLogger


def _has_empty_thinking(block):
    """Return True for thinking blocks with missing or empty content."""
    if not isinstance(block, dict):
        return False
    if block.get("type") != "thinking":
        return False
    thinking = block.get("thinking")
    return not thinking or not thinking.strip()


def _clean_messages(messages):
    if not messages:
        return
    for msg in messages:
        if msg.get("role") == "assistant" and isinstance(msg.get("content"), list):
            msg["content"] = [
                block for block in msg["content"]
                if not _has_empty_thinking(block)
            ]


class StripEmptyThinkingBlocks(CustomLogger):
    async def async_pre_call_hook(self, user_api_key_dict, cache, data, call_type):
        _clean_messages(data.get("messages"))
        return data


strip_empty_thinking_blocks = StripEmptyThinkingBlocks()
