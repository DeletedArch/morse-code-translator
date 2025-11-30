TITLE Morse Code Learning Program
.model small
.stack 100h

.data
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
              
    counter db 0          
    userInput db ?
    ;inputBuffer db 8
    inputBuffer db 6, 0, 6 dup(0)
    empty db " "
    
    testInputMorse db ?
    testInputCharacter db ?
    
    msg1 db "Welcome to Morse Code Learning Program!", 0Dh,0Ah
         db "Select an Option:", 0Dh,0Ah
         db "1. Characters to Morse Code Mapping", 0Dh,0Ah
         db "2. Translate (Character)", 0Dh,0Ah
         db "3. Test", 0Dh,0Ah
         db "4. Exit", 0Dh,0Ah
         db "Type the number of the selected option: $"

    msg2 db "1. Characters to Morse Code Mapping", 0Dh,0Ah,0Dh,0Ah, "$" 
    msg3 db "2. Translate (Character)$"  
    msg4 db "3. Test$"  
    arrowmsg db " -> $"
    spacemsg db "     $"
    errormsg db "Select a valid option (Press any key to continue). $"
    continuemsg db "Press any key to continue...$"
    inputTranslateMsg db "Enter the character to translate : $"    
    outputTranslateMsg db "Translation : $"
    inputTestCharacterMsg db "Enter the character : $"
    inputTestMorseMsg db "Enter the morse code : $"
    outputTestCorrect db "Correct answer $"
    outputTestWrong  db "Wrong answer: $"
    notfoundmsg db "Character not found!"
    
    nl db 0Dh, 0Ah, '$'

.code
main proc
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
    cmp userInput,'4'
    je endprogram
    call newline
    LEA dx, errormsg
    call write
    call read
    jmp program

opt1:
    call option1
    jmp program
    
opt2:
    call option2
    jmp program
    
opt3:
    call option3
    jmp program
    
endprogram:    
    mov ax, 4C00H
    int 21H
main endp

option1 proc near
    call clearScreen
    LEA dx, msg2
    call write
    
    mov si, 0           
    mov di, 0           
    mov counter, 0      
    
option1loop:
    LEA dx, [Characters+si]
    call write
    
    LEA dx, arrowmsg
    call write
    
    LEA dx, [morse+di]
    call write
    
    LEA dx, spacemsg
    call write
    
    inc counter
    
    cmp counter, 2           
    jne skip_newline
    mov counter, 0
    call newline
    
skip_newline:
    cmp si, 70          
    jne continue1
    
    LEA dx, continuemsg
    call write
    call read
    jmp program
    
    continue1:
        add si, 2           
        add di, 6 
        jmp option1loop
    
    ret
option1 endp

option2 proc near
    call clearScreen
    LEA dx, msg3
    call write
    call newline
    LEA dx, inputTranslateMsg
    call write
    call read
    
    mov si, 0           
    mov di, 0
option2loop:
    mov al, [Characters+si]
    cmp al, userInput
    jne continue2
    call newline
    LEA dx, outputTranslateMsg
    call write
    LEA dx, [Characters+si]
    call write
    LEA dx, arrowmsg
    call write
    LEA dx, [morse+di]
    call write
    call read
    jmp program
    
continue2:
     add si, 2           
     add di, 6 
     jmp option2loop

    ret
option2 endp

option3 proc near
    call clearScreen
    LEA dx, msg4
    call write
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
   ; mov al, userInput
   ; mov testInputMorse, al
    
    mov si, 0           
    mov di, 0
option3loop:
    ; Character compare
    mov al, [Characters+si]
    cmp al, testInputCharacter
    je morseCompare
continue3:
    add si, 2           
    add di, 6 
    cmp si, 72          
    jae not_found
    jmp option3loop
    
morseCompare:
    mov cx, 5
    mov bx, 0
    mov bp, di
morseCompareLoop:
    mov al, BYTE PTR ds:[morse+bp]
    mov dl, [inputBuffer+2+bx]
    cmp al, dl
    jne different
    inc bx
    inc bp
    dec cx
    jnz morseCompareLoop
    ; correct
correct:
    call newline
    LEA dx, outputTestCorrect
    call write
    call read
    jmp program
    
different:
    cmp al, ' '
    je check_user_end  
    jmp incorrect     
    
check_user_end:
    cmp dl, 0Dh        
    je correct         
    jmp incorrect
    
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
    call read
    jmp program
not_found:
    call newline
    LEA dx, notfoundmsg ; Character not found!
    call write
    call read
    ret
option3 endp

read proc near
    mov ah, 1
    int 21h
    mov userInput, al
    ret
read endp

readstring proc near
    LEA dx, inputBuffer
    mov ah, 0Ah
    int 21h
    ret
    readstring endp

write proc near
    mov ah, 09h
    int 21h
    ret
write endp
    
newline proc near
    LEA dx, nl
    mov ah, 09h
    int 21h
    ret
newline endp
    
clearScreen proc near
    mov ax, 3
    int 10h
    ret
clearScreen endp


end main
