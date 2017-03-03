TITLE Reading a File (ReadFile.asm)
INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 500000
.data
buffer BYTE BUFFER_SIZE DUP(?)
InputFile BYTE 500 dup(?) , 0
OutputFile BYTE 500 dup(?) , 0
InputFile2 BYTE 500 dup(?) , 0
InputFileHandel HANDLE ?
OutputFileHandel HANDLE ?
InputFileHandel1 HANDLE ?
endlineB BYTE 0dh , 0ah
howManyToWrite DWORD 0															; for every line
string BYTE 5 DUP(?) , 0														; uesd to convert eax to string
stringToHide BYTE 1000 dup(0) , 0														; what we want to hide
bitsTOhide DWORD 0
still_hide DWORD 0
mypower BYTE 128
mychar BYTE 0
stop byte "%"
stringtoout byte 500 dup(0) , 0
actualsize DWORD 0
.code
main PROC
	CALL RUN

	EXIT
main ENDP

RUN PROC

	toinvalide:
	call clrscr
	felnos:
	mov eax , 3
    call SetTextColor 
	mwrite < "To Hide Text Into Image    Press 1" , 0dh , 0ah>
	mwrite < "To Retrive Text From Image Press 2 " , 0dh , 0ah>
	mwrite < "Your Choice : ">
	call readint

	cmp eax , 1
	je tohide

	cmp eax  , 2
	je toretrive

	call clrscr
	mov eax , 20
    call SetTextColor 
	mwrite < "Wrong , Choose Hide Or Retrieve 1/2" , 0dh , 0ah>
	
	jmp felnos


	tohide:
	call clrscr
	CALL takeINPUTandENCREPT													; takes text from user and encrept it	
	mwrite < "Enter the Path of The File (Input) : ">
	mov edx , offset InputFile
	mov ecx,lengthof InputFile
	call readstring
	MOV edx,OFFSET InputFile													; Open the file for input
	CALL Open_File																; opene file and check for error in opening or size is not enough
;;;;;;;;;;;;;;;;
	mwrite < "Enter the Path of The File (OutPut) : ">
	mov edx , offset OutputFile
	mov ecx , lengthof OutputFile
	call readstring
	MOV  EDX , OFFSET OutputFile												; our output file
    Call CreateOutputFile											  
	MOV OutputFileHandel,eax										  								  
	CALL Check_open_file_error									  
;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;														      
	CALL hide_put_in_file														; do every thing :)
;;;;;;;;;;;;;;;;

	close_file::															;close input file and file we save in
	CALL Close_Filee
;;;;;;;;;;;;;;;;
	mwrite < "Done" , 0dh , 0ah>
	jmp con

	toretrive:
	call clrscr
	mwrite < "Enter the Path of The File : ">
	mov edx , offset InputFile2
	mov ecx , lengthof InputFile2
	call readstring
	MOV edx,OFFSET InputFile2													; Open the file for input.
	CALL Open_File																; opene file and check for error in opening or size is not enough
;;;;;;;;;;;;;;;;

	CALL retrive
	

	con:
	mwrite < "To Do Another Hider/Retrive Operation Press 0/N : ">
	call readint
	cmp eax,0
	
	je toinvalide
	quit::
	exit

RUN ENDP

;retrive  Proc
;------------------------------------------
; Receives: 
; Returns: 
;------------------------------------------
retrive PROC

	MOV edi , 0																	; edi is index of file and changes over operations 
	CALL Convert_to_int
	CALL Convert_to_int															; to ignore height and width
;;;;;;;;;;;;;;;;

	MOV ESI , 0																	;index for retrive text	
	go:

		MOV mychar , 0
		MOV mypower , 128

		MOV ECX , 8																; any char is 8 bits

				l1:
					CALL Convert_to_int											; now eax has line of input as a integer
					
					SHR EAX , 1			
					JNC done

					MOV BL , mypower
					ADD mychar , BL
					
					done:
					SHR mypower , 1

					CMP buffer[EDI] , '%'										; is this the end of file ?
					JE close_fileeeee
					
				loop l1		
	

		CMP mychar , 0															; 0 is end of our string
		JE close_fileeeee
		
		MOV AL , mychar
		MOV stringtoout[ESI] , AL
		INC ESI 

	jmp go
	
	close_fileeeee:
	mov ecx , ESI
	mov esi , 0
	CALL decrept								
	mov edx , offset stringtoout
	call writestring
	CALL CRLF
	CALL Close_Filee1

RET
retrive ENDP

;hide_put_in_file  Proc
;------------------------------------------
; Receives: 
; Returns: 
;------------------------------------------

hide_put_in_file PROC

	MOV edi , 0																	; edi is index of file
	mov ecx , 2

	readHieghtANDwidth:
			push ecx
			
			CALL Convert_to_int											; now eax has line of input as a integer
			push edi
			mov edi , offset string
			mov bh , 0
			mov bl , 10
			CALL Convert_to_string			;change bx , edi				; take what in eax , 
																		; convert to string in varible string
			
			CALL write_to_my_output_file

			pop edi
			pop ecx
	loop readHieghtANDwidth

																	
	mov esi , 0																	; esi is index of string to hide
	mov ecx , actualsize												; ok this is our string
	mov stringToHide[ecx] , 0
	inc ecx
	mov eax , ecx 
	imul eax , 8
	mov bitsTOhide , eax														; number of bits to hide

	go:

		cmp ecx , 0																; string end ? ok do not take any other char and do not hide any more
		jle stringDone
		
		mov dl , stringToHide[esi]
		inc esi

		stringDone:
		push ecx
		mov ecx , 8																; any char is 8 bits

				l1:
					push ecx
					CALL Convert_to_int											; now eax has line of input as a integer
					push edi													; edi points to char we should read next
					
					mov ebx , bitsTOhide		
					cmp still_hide , ebx										;string end ? do not hide any thing
					je Dont_hide
					CALL Hide													;bit from char hide in color 
					inc still_hide
					Dont_hide:
					

					mov edi , offset string
					mov bh , 0
					mov bl , 10
					CALL Convert_to_string			;change bx , edi				; take what in eax , 
																				; convert to string in varible string
					pop edi
					
					CALL write_to_my_output_file								; writes line of input file in output file
					
					CMP buffer[edi] , '%'										; is this the end of file ?
					JE outt
					pop ecx
				loop l1		
		pop ecx
		dec ecx

	jmp go

	outt:
	MOV eax , OutputFileHandel
	MOV edx ,  offset stop									; to witer \n in our output file
	MOV ecx , 1	
	CALL write_to_file

	jmp Close_file

hide_put_in_file ENDP

;Open File Proc
;------------------------------------------
; Receives: EAX has handle of file
; Returns: show size of file ,,, checks for errors size and can read or no
;------------------------------------------
Open_File PROC
																  
	CALL OpenInputFile
	MOV InputFileHandel,eax
							 
	CALL Check_open_file_error										; my function		

	MOV edx,OFFSET buffer											; Read the file into a buffer.
	MOV ecx,BUFFER_SIZE
	Call ReadFromFile

																	; error ?  
	JNC check_buffer_size											; error reading?
	mWrite "Error reading file. "								    ; yes: show error message
	Call WriteWindowsMsg
	JMP close_file
	check_buffer_size:
	CMP eax,BUFFER_SIZE												; buffer large enough?
	JB buf_size_ok													; yes
	
	mWrite <"Error: Buffer too small for the file",0dh,0ah>
	JMP quit														; and quit
	buf_size_ok:
	MOV buffer[eax],0												; insert null terminator
																	

	mWrite "File size: "											; display file size
	Call WriteDec                                
	Call Crlf				


RET
Open_File ENDP

;Check_open_file_error Proc
;------------------------------------------
; Receives: EAX has handle of file
; Returns: error or no
;------------------------------------------
Check_open_file_error PROC

	CMP eax,INVALID_HANDLE_VALUE					; error opening file?
	JNE file_ok        
													; no: skip
	mWrite <"Cannot open file",0dh,0ah>
	                             
	exit											; and quit

	file_ok:

	RET
Check_open_file_error ENDP

;write_to_my_output_file Proc
;------------------------------------------
; Receives: EAX has handle of file
; Returns: nothing ,, write to file
;------------------------------------------
write_to_my_output_file PROC uses edx 

	MOV eax , OutputFileHandel
	MOV edx ,  offset string									; write what we converted to our output file
	MOVZX ecx ,  bh
	CALL write_to_file
	
	
	
	MOV eax , OutputFileHandel
	MOV edx ,  offset endlineB									; to witer \n in our output file
	MOV ecx , 2	
	CALL write_to_file


RET
write_to_my_output_file ENDP

;takeINPUTandENCREPT Proc
;------------------------------------------
; Receives: 
; Returns: return actualsize of string
;------------------------------------------
takeINPUTandENCREPT PROC

	mWrite <"Enter TEXT to Hide : ">
	mov edx , offset stringToHide
	mov ecx , lengthof stringToHide -1
	CALL readstring
	mov actualsize,eax
	mov esi , 0
	mov ecx , actualsize
	CALL encrept


RET
takeINPUTandENCREPT ENDP

;Convert_string_to_int Proc
;------------------------------------------
; Receives: EDI as index
; Returns: EAX = Number converted from string
;-----
Convert_to_int PROC 
	
	mov howManyToWrite , 0
	XOR EAX , EAX 
	XOR EBX , EBX
	
	read_line:								;;;;;; convert string to int
	
		CMP buffer[edi] , 0dh
		JE outt										;;;;;; line read seccuessfuly 
		MOVZX ebx , byte ptr buffer[edi]
		SUB ebx , '0'
		IMUL eax , 10
		ADD eax ,  ebx
		INC edi
		INC howManyToWrite

	jmp read_line

	outt:
	ADD edi , 2									 ;;;;;;;;;;;;;;;;;;;;; to skip 0dh and 0ah
RET
Convert_to_int ENDP 

;Convert_int_to_string Proc
;------------------------------------------
; Receives: EAX is the number
; Returns:  varible string has eax as string
;		 :  bx has number of bits to write
;------------------------------------------
Convert_to_string PROC uses eax

	xor ah , ah
	div bl					;al=ax/10 , ah=ax%10
	cmp ax , 0
	je outt
	CALL Convert_to_string

	mov al , ah
	add al , '0'

	mov [edi] , al
	add edi , 1
	inc bh
	outt:

RET
Convert_to_string ENDP

;encrept  Proc
;------------------------------------------
; Receives: esi as index 0 of string , ecx , lentghof string 
; Returns: nothing ,, changes the string -> decrept it 
;------------------------------------------
encrept PROC uses esi ecx eax

L1:
	mov al,stringToHide[esi]
	xor al,239
	mov stringToHide[esi],al
	inc esi
	loop L1
RET
encrept ENDP

;Hide Proc
;------------------------------------------
; Receives: EAX is number of r pr g or b and dl is char 
; Returns:  eax is new number hides bit of char in it 
;------------------------------------------
Hide PROC  

	shl dl , 1
	jc isone

	and eax , 0fffeh
	jmp done
	isone:
	or eax , 0001h

	done:
RET
Hide ENDP

;decrept  Proc
;------------------------------------------
; Receives: esi as index 0 of string , ecx , lentghof string 
; Returns: nothing ,, changes the string -> decrept it 
;------------------------------------------
decrept PROC uses ecx esi eax

L2:
	mov al,stringtoout[esi]
	xor al,239
	mov stringtoout[esi],al
	inc esi
loop L2

RET
decrept ENDP


;write_to_file Proc
;------------------------------------------
; Receives: EAX has handle of file
; Returns: nothing ,, error or no
;------------------------------------------
write_to_file PROC

	CALL WriteToFile
	JNC   outt

	mWrite <"Error cant write to file:",0dh,0ah>
	exit

	outt:
RET
write_to_file ENDP

;-------------------------------------
;Close File Proc
;------------------------------------------
; Receives: EAX has handle of file
; Returns: no thing ,, close file 
;------------------------------------------
Close_Filee PROC

	MOV eax , OutputFileHandel
	Call CloseFile
	MOV eax , InputFileHandel
	Call closefile

RET
Close_Filee ENDP

Close_Filee1 PROC

	MOV eax , InputFileHandel1
	Call closefile

RET
Close_Filee1 ENDP

END main

DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD
mov eax, 1 ; Return true to caller.
ret
DllMain ENDP
END DllMain