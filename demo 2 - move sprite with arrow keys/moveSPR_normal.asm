
	;;--- CODE START ---;;
	.inesprg 1
	.inesmap 0
	.inesmir 1
	.ineschr 1

	.bank 1     
	.org $FFFA
	.dw 0        ; no VBlank
	.dw Start    ; address to execute on reset
	.dw 0        ; no whatever

	.bank 0
	.org $0000
X_Pos   .db 20       ; a X position for our sprite, start at 20
Y_Pos   .db 20      ; a Y position for our sprite, start at 20

	.org $8000  ; code starts at $8000 or $C000
Start:

	lda #%00001000  ;
	sta $2000       ; 
	lda #%00011110  ; Our typical PPU Setup code.
	sta $2001       ; 

	ldx #$00    ; clear X            ;; start of pallete loading code

	lda #$3F    ; have $2006 tell
	sta $2006   ; $2007 to start
	lda #$00    ; at $3F00 (pallete).
	sta $2006

loadpal:                ; this is a freaky loop
	lda tilepal, x  ; that gives 32 numbers
	sta $2007       ; to $2007, ending when
	inx             ; X is 32, meaning we
	cpx #32         ; are done.
	bne loadpal     ; if X isn't =32, goto "loadpal:" line.
	                                ;; end of pallete loading code

infinite:  ; a label to start our infinite loop
waitblank:         
	lda $2002  ; these 3 lines wait for VBlank, this loop will actually miss VBlank
	bpl waitblank ; alot, in a later Day, I'll give a better way.

	lda #$00   ; these lines tell $2003
	sta $2003  ; to tell
	lda #$00   ; $2004 to start
	sta $2003  ; at $0000.

;sprite 1
	lda Y_Pos  ; load Y value
	sta $2004 ; store Y value

	lda #$00  ; tile number 0
	sta $2004 ; store tile number

	lda #$00 ; no special junk
	sta $2004 ; store special junk

	lda X_Pos  ; load X value
	sta $2004 ; store X value
	; and yes, it MUST go in that order.

;sprite2
	lda Y_Pos  ; load Y value
	sta $2004 ; store Y value

	lda #$01  ; tile number 1
	sta $2004 ; store tile number

	lda #$00 ; no special junk
	sta $2004 ; store special junk

	lda X_Pos  ; load X value
    adc #$7
	sta $2004 ; store X value
	; and yes, it MUST go in that order.

;sprite3
	lda Y_Pos  ; load Y value
	adc #$7
	sta $2004 ; store Y value

	lda #16  ; tile number 1
	sta $2004 ; store tile number

	lda #$00 ; no special junk
	sta $2004 ; store special junk

	lda X_Pos  ; load X value
    
	sta $2004 ; store X value
	; and yes, it MUST go in that order.

;sprite4
	lda Y_Pos  ; load Y value
	adc #$7
	sta $2004 ; store Y value

	lda #17  ; tile number 1
	sta $2004 ; store tile number

	lda #$00 ; no special junk
	sta $2004 ; store special junk

	lda X_Pos  ; load X value
    adc #$7
	sta $2004 ; store X value
	; and yes, it MUST go in that order.
	
	lda #$01   ; these
	sta $4016  ; lines
	lda #$00   ; setup/strobe the 
	sta $4016  ; keypad.

	lda $4016  ; load Abutton Status ; note that whatever we ain't interested
	lda $4016  ; load Bbutton Status ; in we just load so it'll go to the next one.
	lda $4016  ; load Select button status
	lda $4016  ; load Start button status
	lda $4016  ; load UP button status
	and #1     ; AND status with #1
	bne UPKEYdown  ; for some reason (not gonna reveal yet), need to use NotEquals
	;with ANDs. So it'll jump (branch) if key was down.
	
	lda $4016  ; load DOWN button status
	and #1     ; AND status with #1
	bne DOWNKEYdown

	lda $4016  ; load LEFT button status
	and #1     ; AND status with #1
	bne LEFTKEYdown

	lda $4016  ; load RIGHT button status
	and #1     ; AND status with #1
	bne RIGHTKEYdown
	jmp NOTHINGdown  ; if nothing was down, we just jump (no check for conditions)
	; down past the rest of everything.

UPKEYdown:
	lda Y_Pos ; load A with Y position
	sbc #1  ; subtract 1 from A. Only can do math on A register. SBC (Subtract with Borrow)
	sta Y_Pos ; store back to memory
	jmp NOTHINGdown  ; jump over the rest of the handling code.

DOWNKEYdown:
	lda Y_Pos 
	adc #1  ; add 1 to A. ADC (Add with Carry)((to A register))
	sta Y_Pos
	jmp NOTHINGdown ; jump over the rest of handling code.

LEFTKEYdown:
	lda X_Pos
	sbc #1  
	sta X_Pos
	jmp NOTHINGdown 
;the left and right handling code does the same as UP and Down except.. well.. with
; left and right. :)

RIGHTKEYdown:
	lda X_Pos
	adc #1
	sta X_Pos
	; don't need to jump to NOTHINGdown, it's right below. Saved several bytes of
	; PRG-Bank space! :)

NOTHINGdown:
	jmp infinite

tilepal:   .incbin "our.pal"  ; a label for our pallete data

	.bank 2
	.org $0000
	.incbin "sprite.bkg"
	.incbin "sprite.spr"

;;--- END OF CODE FILE ---;;
