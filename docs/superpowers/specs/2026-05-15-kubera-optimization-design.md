# Kubera Optimization & Refactoring Design

**Date**: 2026-05-15  
**Status**: Approved  
**Topic**: Decomposing AiService & Standardizing API

## 1. Objective
Refactor the monolithic `AiService` (595 lines) into a modular structure, standardize API controller responses, and resolve local environment build issues to enable testing.

## 2. Architecture Changes

### AI Namespace (`app/services/ai/`)
The current `AiService` violates SRP by handling setup, API calls, parsing, and advice. We will decompose it into:

| Component | Responsibility |
|-----------|----------------|
| `Ai::Orchestrator` | Coordinates the flow, remains as `AiService` for backward compatibility. |
| `Ai::SetupService` | Ollama/OpenRouter configuration flow and system detection. |
| `Ai::Provider` | Interface for OpenAI/Ollama API calls. |
| `Ai::CommandParser` | Natural language parsing for transactions and budgets. |
| `Ai::AdviceService` | Rule-based financial advice logic. |
| `Ai::Formatter` | Shared formatting logic (e.g., Rupee formatting). |

### API Controller Standardization
We will update `Api::BaseController` to provide helper methods for consistent JSON responses:
- `render_success(data, message: nil, status: :ok)`
- `render_error(message, status: :unprocessable_entity)`
- `render_unauthorized(message = "Unauthorized")`

## 3. Environment Stabilization
- Focus on resolving `io-console` and other native gem build failures.
- Target: Run `bin/rubocop` and `bin/rspec` successfully.

## 4. Phased Implementation Plan
1. **Phase 1**: Environment Fix (Enable testing/linting).
2. **Phase 2**: AI Service Decomposition (Modularize logic).
3. **Phase 3**: Controller Refactoring (Standardize responses).
4. **Phase 4**: Cleanup & Optimization (Remove redundant code).
