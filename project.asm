TITLE Morse Code Learning Program
.model small

.stack 100h

.data
; Arrays
    Characters db 'a$','b$','c$','d$','e$','f$','g$','h$','i$','j$','k$','l$','m$','n$','o$','p$','q$','r$','s$','t$','u$','v$','w$','x$','y$','z$','0$','1$','2$','3$','4$','5$','6$','7$','8$','9$'
    morse db ".-   $"  ; a
          db "-... $"  ; b
          db "-.-. $"  ; c
          db "-..  $"  ; d
          db ".    $"  ; e
          db "..-. $"  ; f
          db "--.  $"  ; g
          db ".... $"  ; h
          db "..   $"  ; i
          db ".--- $"  ; j
          db "-.-  $"  ; k
          db ".-.. $"  ; l
          db "--   $"  ; m
          db "-.   $"  ; n
          db "---  $"  ; o
          db ".--. $"  ; p
          db "--.- $"  ; q
          db ".-.  $"  ; r
          db "...  $"  ; s
          db "-    $"  ; t
          db "..-  $"  ; u
          db "...- $"  ; v
          db ".--  $"  ; w
          db "-..- $"  ; x
          db "-.-- $"  ; y
          db "--.. $"  ; z
          db "-----$"  ; 0
          db ".----$"  ; 1
          db "..---$"  ; 2
          db "...--$"  ; 3
          db "....-$"  ; 4
          db ".....$"  ; 5
          db "-....$"  ; 6
          db "--...$"  ; 7
          db "---..$"  ; 8
          db "----.$"  ; 9
              
; Messages
    ; General
    msg1 db "Welcome to Morse Code Learning Program!", 0Dh,0Ah
         db "Select an Option:", 0Dh,0Ah
         db "1. Characters to Morse Code Mapping (All Characters)", 0Dh,0Ah
         db "2. Character to Morse Code Mapping", 0Dh,0Ah
         db "3. Test", 0Dh,0Ah
         db "4. Exit", 0Dh,0Ah
         db "Type the number of the selected option: $"
    errormsg db "Select a valid option! (Press any key to continue). $"
    arrowmsg db " -> $" ;option 1,2,3
    restartmsg db "Press any key to restart...$" ;option 2,3 
    nl db 0Dh, 0Ah, '$'
    ; Option 1
    msg2 db "1. Characters to Morse Code Mapping (All Characters)$" 
    spacemsg db "     $"
    continuemsg db "Press any key to continue...$"
    ; Option 2
    msg3 db "2. Character to Morse Code Mapping$"
    inputTranslateMsg db "Enter the character to translate : $"    
    outputTranslateMsg db "Translation : $"
    ; Option 3
    msg4 db "3. Test$"  
    inputTestCharacterMsg db "Enter the character : $"
    inputTestMorseMsg db "Enter the morse code : $"
    outputTestCorrect db "Correct answer $"
    outputTestWrong  db "Wrong answer... Correct answer: $"
    notfoundmsg db "Character not found!$"
    
; Other Variables
    ; General
    userInput db ? ;+option 2,3
    ; Option 1
    counter db 0          
    ; Option 2
    ; Option 3
    inputBuffer db 6, 0, 6 dup(0)
    testInputCharacter db ?

.code
main proc far
startprogram:
    mov ax, @data
    mov ds, ax
    
program:
    call clearScreen
    
    LEA dx, msg1
    call write
    call read
    cmp userInput,'1'
    je opt1
    cmp userInput,'2'
    je opt2
    cmp userInput,'3'
    je opt3
    cmp userInput,'4' ;exit
    je endprogram
    ;default case
    call newline
    LEA dx, errormsg
    call write
    call read
    jmp program
; Option 1 calling
opt1:
    call option1
    jmp program
; Option 2 calling
opt2:
    call option2
    jmp program
; Option 3 calling
opt3:
    call option3
    jmp program
    
endprogram:    
    mov ax, 4C00H
    int 21H
main endp

; Option 1
option1 proc near
    ; Introductory Text
    call clearScreen
    LEA dx, msg2
    call write
    call newline
    
    ; InitialiZing registers for the loop
    mov si, 0           
    mov di, 0           
    mov counter, 0 ;columns   
    
    ; Loop
option1loop:
    ; Type an element
    LEA dx, [Characters+si]
    call write
    
    LEA dx, arrowmsg
    call write
    
    LEA dx, [morse+di]
    call write
    
    LEA dx, spacemsg
    call write
    
    inc counter
    
    ; Skipping newline for columns
    cmp counter, 2 ; Control number of columns         
    jne skip_newline
    mov counter, 0
    
    call newline
    
skip_newline:
    ; Condition to end the loop
    cmp si, 70          
    je endoption1loop
    ; Continue loop
    add si, 2           
    add di, 6 
    jmp option1loop
endoption1loop:
    LEA dx, continuemsg
    call write
    call read
    ret
option1 endp

; Option 2
option2 proc near
    ; Introductory Text
    call clearScreen
    LEA dx, msg3
    call write
    
    ; Recieving input from user
    call newline
    LEA dx, inputTranslateMsg
    call write
    call read
    
    ; InitialiZing registers for the loop
    mov si, 0           
    mov di, 0
    
    ; Loop
option2loop:
    ; Search for the character
    mov al, [Characters+si]
    cmp al, userInput
    je found
;not found this iteration
    cmp si, 70          
    je endoption2loop ;not found all iterations
    add si, 2           
    add di, 6 
    jmp option2loop ;next iteration
endoption2loop:
    call newline
    LEA dx, notfoundmsg
    call write
    call newline
    LEA dx, restartmsg
    call write
    call read
    ret
found:
    call newline
    LEA dx, outputTranslateMsg
    call write
    LEA dx, [Characters+si]
    call write
    LEA dx, arrowmsg
    call write
    LEA dx, [morse+di]
    call write
    call newline
    LEA dx, restartmsg
    call write
    call read
    ret
option2 endp

; Option 3
option3 proc near
    ; Introductory Text
    call clearScreen
    LEA dx, msg4
    call write
    
    ; Recieve input from User
    call newline
    LEA dx, inputTestCharacterMsg
    call write
    call read
    mov al, userInput
    mov testInputCharacter, al
    call newline
    LEA dx, inputTestMorseMsg
    call write
    call readstring
    
    ; InitialiZing registers for the loop
    mov si, 0           
    mov di, 0
    
    ; Loop
option3loop:
    ; Search for the character
    ; Character compare
    mov al, [Characters+si]
    cmp al, testInputCharacter
    je morseCompare; found
;not found this iteration
    cmp si, 70          
    je endoption3loop ;not found all iterations
    add si, 2           
    add di, 6 
    jmp option3loop ;next iteration
    
endoption3loop:
    call newline
    LEA dx, notfoundmsg
    call write
    call newline
    LEA dx, restartmsg
    call write
    call read
    ret
    
    ; Check Morse code
morseCompare:
    mov cx, 5 ; number of characters to check (maximum digits for morse code is 5)
    mov bx, 0
    mov bp, di
morseCompareLoop:
    mov al, BYTE PTR ds:[morse+bp]
    mov dl, [inputBuffer+2+bx]
    cmp al, dl
    jne different ; if the same continue comparing if different check
    inc bx
    inc bp
    dec cx
    jnz morseCompareLoop; end loop when cx = zero
    jmp correct
different:
    ;check if correct morse code ended
    cmp al, ' '
    jne incorrect
    
    ;check if user's morse code ended
    cmp dl, 0Dh        
    jne incorrect

correct:
    call newline
    LEA dx, outputTestCorrect
    call write
    call newline
    LEA dx, restartmsg
    call write
    call read
    ret
incorrect:
    call newline
    LEA dx, outputTestWrong
    call write
    LEA dx, [Characters+si]
    call write
    LEA dx, arrowmsg
    call write
    LEA dx, [morse+di]
    call write
    call newline
    LEA dx, restartmsg
    call write
    call read
    ret
option3 endp

; Functions
; Read Character
read proc near
    mov ah, 01h
    int 21h
    mov userInput, al
    ret
read endp
; Read String
readstring proc near
    LEA dx, inputBuffer
    mov ah, 0Ah
    int 21h
    ret
readstring endp
; Write
write proc near
    mov ah, 09h
    int 21h
    ret
write endp
; Write Newline
newline proc near
    LEA dx, nl
    mov ah, 09h
    int 21h
    ret
newline endp
; Clear Terminal Screen
clearScreen proc near
    mov ax, 3
    int 10h
    ret
clearScreen endp

end main