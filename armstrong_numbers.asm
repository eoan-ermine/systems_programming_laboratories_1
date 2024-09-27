section .data
    format: db '%d',10

global main
section .text

extern printf

pow:
   ; Входные данные:
   ; rcx - число, которое нужно возвести в степень
   ; rdx - степень, в которую нужно возвести число
   ; Выход:
   ; rax - результат возведения rcx в степень rdx
   ; Используемые переменные:
   ; r9 - оригинальное число, которое нужно возвести в степень (начальное значение: r10)
   ; r10 - переменная, используемая для вычислений (начальное значение: rcx)
   ; r11 - степень, в которую нужно возвести число (начальное значение: rdx)
   ; r8 - счетчик, в какую степень уже возведено r10 (начальное значение: 0)

    mov r10, rcx ; int number (arg)
    mov r11, rdx ; int power (arg)
    dec r11 ; у нас уже есть число, возведенное в первую степень, так что уменьшаем степень на 1
    mov r9, r10 ; int original_number = number
    mov r8, 0 ; int i = 0
    mov rax, r10 ; промежуточный результат: оригинальное число
__condition0:
    cmp r8, r11 ; сравниванием, в какую степень возведено, и в какую степень нужно возвести
    jne __loop0 ; если они еще не равны, то идем возводить
    ret ; иначе выходим из функции: результат уже лежит в rax
__loop0:
    mov rax, r10 ; rax - то, что нужно умножить
    mov rdx, r9 ; rdx - то, на что умножаем
    mul rdx ; умножаем rax на rdx, результат сохраняется в rax
    mov r10, rax ; сохраняем результат умножения в нашу переменную
    inc r8 ; и инкрементируем счетчик, что мы посчитали степень
    jmp __condition0 ; переходим к проверке, завершено ли возведение

number_of_digits:
    ; Входные данные:
    ; rcx - число, количество цифр в котором необходимо посчитать
    ; Выходные данные:
    ; rax - количество цифр в переданном числе
    ; Используемые переменные:
    ; r8 - копия rcx
    ; r9 - счетчик цифр в числе r8
    mov r8, rcx ; int number (arg)
    mov r9, 0 ; int i = 0
__condition1:
    cmp r8, 0 ; Сравниваем число с нулем: для проверки, перебрали ли мы все разряды
    jne __loop1 ; Если не перебрали, идем перебирать
    mov rax, r9 ; Иначе перемещаем r9 в rax
    ret ; И выходим из функции
__loop1:
    mov rax, r8 ; Перемещаем число в rax для того, чтобы потом его поделить
    cqo ; производим расширение для дальнейшего деления
    mov rcx, 10 ; rcx - то, на что мы делим
    idiv rcx ; производим целочисленное деление rax на rcx
    mov r8, rax ; обновляем значение в r8
    inc r9 ; и обновляем счетчик, что мы посчитали очередной десятичный разряд
    jmp __condition1 ; переходим к проверке, не завершен ли подсчет цифр

main:
    ; Используемые переменные:
    ; r15 - текущее число, для которого происходит вычисление (начальное значение: 1)
    ; r12 - копия r15 для использования в вычислении (начальное значение: r15)
    ; r13 - результат вычисления (начальное значения: 0)
    ; r14 - количество цифр в числе r12

    mov r15, 1

 __loop3:
    mov rbx, r15 ; int original_number
    mov r12, r15 ; int number
    mov r13, 0 ; int result
    mov rcx, r12 ; number_of_digits ожидает свой аргумент в rcx
    call number_of_digits ; вызываем функцию number_of_digits
    mov r14, rax ; int i = number_of_digits(number)

__condition2:
    cmp r12, 0 ; r12 равное 0 свидетельствует о том, что мы посчитали result
    jne __loop2 ; если мы не посчитали его, нам нужно его досчитать

    cmp rbx, r13 ; сравниваем, является ли посчитанный result искомым числом
    je __print ; если является, то печатаем его
    jmp __continue_iter ; иначе идем проверять следующее число

__print:
    mov rdi, format ; строка, которая передается printf
    mov rsi, r13 ; аргумент, передаваемый printf
    mov eax, 0 ; переменное количество аргументов
    call printf ; вызываем printf

__continue_iter:
    inc r15 ; инкрементируем число
    cmp r15, 0 ; если оно дошло до нуля - значит, оно переполнилось, и мы дальше считать не можем
    jne __loop3 ; если не дошло - переходим к вычислению

    ret ; если дошло - выходим
__loop2:
    mov rax, r12 ; rax - что делим
    cqo ; расширяем его знак для деления
    mov rcx, 10 ; rcx - то, на что делим
    idiv rcx ; rax - результат, rdx - остаток
    mov r12, rax ; сохраняем результат в переменную

    mov rcx, rdx ; rcx - аргумент pow - то, что возводим в степень
    mov rdx, r14 ; rdx - аргумент pow - то, во что возводим в степень
    call pow ; вызываем pow
    add r13, rax ; добавляем результат pow к переменной result

    jmp __condition2 ; переходим к сравнению: посчитан ли result?
