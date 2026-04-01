
# Ollama Model Factory

Simple scripts to build Ollama models from `models/Modelfile.*`.

---

## Available Models

This repository provides a set of optimized Ollama models tailored for:

* Apple Silicon (M-series, tested on M3 Pro 18GB)
* Fast inference
* Low hallucination
* DevOps and multi-language development (Go, Bash, Python)

---

## Models Overview

### `qwen25-stable` (Default)

**Base:** `qwen2.5:7b-q4_K_M`
**Use case:** General tasks, factual responses, scripting support

* Low hallucination
* Reliable outputs
* Best default model

Best for:

* Bash scripting
* Python utilities
* Infrastructure documentation
* General queries

---

### `qwen25-fast` (Ultra Fast)

**Base:** `qwen2.5:7b-q4_K_M`
**Use case:** Automation, agents, quick scripts

* Very fast responses
* Deterministic output
* Minimal resource usage

Best for:

* Bash one-liners
* Automation pipelines
* n8n or agent workflows

---

### `qwen3-balanced` (Development and Coding)

**Base:** `qwen3:8b-q4_K_M`
**Use case:** Software development and debugging

* Strong reasoning
* Structured output
* Better code generation

Best for:

* Go (Golang) services
* API design
* Kubernetes and Helm configurations
* Debugging complex issues
* Python backend logic

---

### `qwen35-precision` (Deep Engineering)

**Base:** `qwen3.5:9b-q4_K_M`
**Use case:** Advanced architecture and deep debugging

* Highest accuracy
* Strong reasoning
* Low hallucination (with tuning)

Best for:

* System design
* Distributed systems
* Performance tuning
* Complex Go and Python debugging

---

### `qwen35-fast` (Fast 9B Mode)

**Base:** `qwen3.5:9b-q4_K_M`
**Use case:** Faster deep reasoning

* Reduced latency compared to precision model
* Balanced performance

Best for:

* Medium complexity coding tasks
* Faster architecture discussions

---

## Build Models

```bash
./scripts/build-model.sh <model> [tag]
```

### Examples

```bash
./scripts/build-model.sh qwen25-stable
./scripts/build-model.sh qwen25-fast
./scripts/build-model.sh qwen3-balanced
./scripts/build-model.sh qwen35-precision
./scripts/build-model.sh qwen35-fast
```

---

## Recommended Usage Strategy

| Task                           | Model              |
| ------------------------------ | ------------------ |
| General or factual             | `qwen25-stable`    |
| Bash or automation             | `qwen25-fast`      |
| Go or Python development       | `qwen3-balanced`   |
| Deep debugging or architecture | `qwen35-precision` |
| Faster deep tasks              | `qwen35-fast`      |

---

## Language-Specific Guidance

### Go (Golang)

* Use: `qwen3-balanced` or `qwen35-precision`
* Suitable for:

  * Microservices (Chi, REST)
  * Concurrency patterns
  * API design
  * Performance tuning

### Bash

* Use: `qwen25-fast`
* Suitable for:

  * One-liners
  * CI/CD scripts
  * System automation

### Python

* Use:

  * `qwen25-stable` for simple scripts
  * `qwen3-balanced` for backend logic
  * `qwen35-precision` for complex debugging

---

## Performance Guidelines

* Use quantized models (`q4_K_M`)
* Keep `num_ctx` less than or equal to 4096
* Keep `num_predict` less than or equal to 256
* Run Ollama natively on macOS instead of Docker
* Maintain approximately 4 to 6 GB free RAM

---

## System Requirements

* Apple Silicon (M1, M2, or M3)
* At least 16 GB RAM (18 GB tested)
* Metal GPU support

---

## Notes

* Large context sizes (such as 256K) are not practical for local setups
* Recommended context range: 2048 to 4096
* Use smaller models (7B) for most workloads
* Switch to 9B models only when necessary

---

## Future Improvements

* Model routing (automatic selection per task)
* API gateway for internal AI usage
* Kubernetes-native deployment
* Integration with DevOps pipelines

---

