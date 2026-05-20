# Лабораторная работа №3 — Анализ пайплайна SCR1

**Студент:** Иван Калинин
**Вариант:** 1 (xor, вывод регистров состояния)

## Цель
Исследовать выполнение команды `xor` в конвейере процессора SCR1, добавить отладочный модуль для детектирования команды.

## Выполненные шаги
1. Создана ветка `lab3_scr1_pipe_analysis`
2. В `rv32_tests.inc` оставлен только тест `xor.S`
3. Симуляция с waveform: **1/1 PASS**
4. На waveform добавлены сигналы: `clk`, `core_imem_req`, `core_imem_addr`, `core_imem_resp`, `core_imem_rdata`
5. На 465 пс зафиксирована инструкция `xor` (`0020C1B3`)
6. Создан отладочный модуль `scr1_tb_log_cmd.sv`, выводящий `DETECTED: xor instruction`

## Сигналы на waveform
| Сигнал | Назначение |
|--------|------------|
| `clk` | Тактовый импульс |
| `core_imem_req` | Запрос к памяти инструкций |
| `core_imem_addr` | Адрес инструкции |
| `core_imem_resp` | Ответ памяти (`01` — данные готовы) |
| `core_imem_rdata` | Данные инструкции |

## Отладочный модуль
```verilog
module scr1_tb_log_cmd(
    input logic clk,
    input logic [1:0] imem_resp,
    input logic [31:0] imem_rdata
);

always_ff @(posedge clk) begin
    if ((imem_rdata[6:0] == 7'b0110011) &&
        (imem_rdata[14:12] == 3'b100) &&
        (imem_rdata[31:25] == 7'b0000000)) begin
        $display("DETECTED: xor instruction at time %0t", $time);
    end
end

endmodule