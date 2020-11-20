

		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
		
Start
	VLDR.F32 S0, =5		;Tiempo de la llamada.
	;Constantes
	VLDR.F32 S1, =1				
	VLDR.F32 S2, =3			
	VLDR.F32 S3, =0.50		
	VLDR.F32 S4, =0.10		
	VLDR.F32 S5, =0.60		

ValI
	VADD.F32 S6, S0
	VADD.F32 S7, S0
	B Costo1
	
;Cobro 3min.
Costo1
	VCMP.F32 S6, S2
	VMRS APSR_nzcv, FPSCR
	BGT	SumaC1
	BNE	RestaC1
	
SumaC1
	VADD.F32 S8, S8, S3        ;Q0.50+
	VSUB.F32 S6, S6, S2
	BL Costo1			
RestaC1
	VSUB.F32 S7, S7, S2
	B Costo2

;tiempo de extra.
Costo2
	VCMP.F32 S7, S1
	VMRS APSR_nzcv, FPSCR
	BGT	SumaC2
	BNE SumaSobrante
	
SumaC2
	VADD.F32 S9, S9, S4			;Q0.10+
	VSUB.F32 S7, S7, S1
	BL Costo2
	
;tiempo menor a 1min
SumaSobrante
	VDIV.F32 S10, S4, S5
	VMUL.F32 S7, S7, S10
	VADD.F32 S9, S9, S7
	B Total
		
Total
	VLDR.F32 S1, =0
	VADD.F32 S1, S9, S8			;Coste total S1.
	B Loop
			
Loop
	
	ALIGN      
	END	