program eddington
IMPLICIT REAL(4)(A-H, K-Z)
integer::i,n,l1,l,j
parameter(n=2)
real(4):: fdu1(n),fuu1(n),fdu1w(n),fuu1w(n),fdu1g(n),fuu1g(n),fdu1wg(n),fuu1wg(n),fdu(n),fuu(n),Bench(1000),mu(90),p(257)
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
!Do 2000   uii = -1.00 , 2.01 ,0.1    !31
!t0=10.0**uii
!Do 1000 ujj=0.0099,1.01,0.05   !21
!u0 = min(ujj,1.0)
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
!Do 2000 ujj = 1 , 100
u0 = 0.5
u = 0.7074532
!u0=0.5
!Do 3000 uii = 1 , 20
!Do 2000 ujj = 1 , 100
!t0=ujj
!t0=84.372735353535400
t0=66.2377535353535
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
sigmaw=0.000 ; sigmag=0.000
!sigmaw=-8.224879532622400e-06 ; sigmag=4.351226591331250e-05
!sigmaw=-9.982859170768868e-06 ; sigmag=5.281254528887848e-05                                                                                 
ww=1-0.005532247346190 ; g=0.780812663379802 ; f0=1 ; rr=0.0
!!ww=1-0.004005156074249 ; g=0.772733857941188 ; f0=1 ; rr=0.0
pi=3.1415927
fdu1(1)=0 ; fdu1(2)=0 ; fuu1(1)=0 ; fuu1(2)=0
fdu1w(1)=0 ; fdu1w(2)=0 ; fuu1w(1)=0 ; fuu1w(2)=0
fdu1g(1)=0 ; fdu1g(2)=0 ; fuu1g(1)=0 ; fuu1g(2)=0
fdu(1)=0 ; fdu(2)=0 ; fuu(1)=0 ; fuu(2)=0
!ff=g**2
ff=0
ww1=ww
g1=(g-ff)/(1-ff)
sigmag1=sigmag/(1.-ff)
!cccccccccccccccccccccccccccc直射项的处理cccccccccccccccccccccccccccccccccccccccccccccccccc
n1=1-ww1*ff
mm1=exp(-n1*t0/u0)
!cccccccccccccccccccccccccccc均匀层结Eddtington解cccccccccccccccccccccccccccccccccccccccccc
y1=1.75-(0.75*ff+1)*ww1-0.75*(1-ff)*ww1*g1
y2=-0.25-(0.75*ff-1)*ww1-0.75*(1-ff)*ww1*g1
y_u_5=(1-ff)*ww1*(0.5-0.75*g1*u0)*pi*f0 ; y_d_5=(1-ff)*ww1*(0.5+0.75*g1*u0)*pi*f0
k=sqrt(y1**2-y2**2)
alpha_u=0.5*(1+(y1-y2)/k) ; alpha_d=0.5*(1-(y1-y2)/k)
mm2=exp(-k*t0)
G_u_1=u0*u0/(n1*n1-u0*u0*k*k)*(n1/u0*y_u_5-y1*y_u_5-y2*y_d_5)
G_d_1=-u0*u0/(n1*n1-u0*u0*k*k)*(n1/u0*y_d_5+y1*y_d_5+y2*y_u_5)
C_10=(alpha_u*mm1*(rr*G_d_1-G_u_1+rr*u0*pi*f0)+(alpha_d-rr*alpha_u)*G_d_1*mm2)/(alpha_u*(alpha_u-rr*alpha_d)-alpha_d*(alpha_d-rr*alpha_u)*mm2*mm2)
C_20=(-G_d_1-alpha_d*C_10*mm2)/alpha_u
fuu1(1)=alpha_u*C_10*mm2+alpha_d*C_20+G_u_1
fdu1(2)=alpha_d*C_10+alpha_u*C_20*mm2+G_d_1*mm1
!ccccccccccccccccccccccccccccsigmaw方程解cccccccccccccccccccccccccccccccccccccc
if ( sigmaw .ne. 0. ) then
y_1w=-(0.75*ff+1)-0.75*(1-ff)*g1 ; y_2w=-(0.75*ff-1)-0.75*(1-ff)*g1
y_u_5w=(1-ff)*(0.5-0.75*g1*u0)*pi*f0 ; y_d_5w=(1-ff)*(0.5+0.75*g1*u0)*pi*f0

chi_u_1w=(y_1w+y_2w)*t0*(alpha_d-alpha_u)*C_10/2.
chi_d_1w=(y_2w-y_1w)*t0*(alpha_d+alpha_u)*C_10/2.
chi_u_2w=(y_1w+y_2w)*t0*(alpha_u-alpha_d)*C_20/2.
chi_d_2w=(y_2w-y_1w)*t0*(alpha_u+alpha_d)*C_20/2.
chi_u_3w=(y_1w+y_2w)*(alpha_u-alpha_d)*C_10
chi_d_3w=(y_1w-y_2w)*(alpha_u+alpha_d)*C_10
chi_u_4w=(y_1w+y_2w)*(alpha_d-alpha_u)*C_20
chi_d_4w=(y_1w-y_2w)*(alpha_d+alpha_u)*C_20
chi_u_5w=(y_1w+y_2w)*t0*(G_d_1-G_u_1)/2.+(y_u_5w-y_d_5w)*t0/2.
chi_d_5w=(y_2w-y_1w)*t0*(G_d_1+G_u_1)/2.+(y_u_5w+y_d_5w)*t0/2.
chi_u_6w=(y_1w+y_2w)*(G_u_1-G_d_1)-(y_u_5w-y_d_5w)+ff*t0*(y_u_5-y_d_5)/(2*u0)
chi_d_6w=(y_1w-y_2w)*(G_u_1+G_d_1)-(y_u_5w+y_d_5w)+ff*t0*(y_u_5+y_d_5)/(2*u0)
chi_u_7w=-ff*(y_u_5-y_d_5)/(2*u0)
chi_d_7w=-ff*(y_u_5+y_d_5)/(2*u0)

phi_u_1w=(y1+y2)*chi_d_1w+k*chi_u_1w+chi_u_3w
phi_d_1w=(y1-y2)*chi_u_1w+k*chi_d_1w+chi_d_3w
phi_u_2w=(y1+y2)*chi_d_2w-k*chi_u_2w+chi_u_4w
phi_d_2w=(y1-y2)*chi_u_2w-k*chi_d_2w+chi_d_4w
phi_u_3w=(y1+y2)*chi_d_3w+k*chi_u_3w
phi_d_3w=(y1-y2)*chi_u_3w+k*chi_d_3w
phi_u_4w=(y1+y2)*chi_d_4w-k*chi_u_4w
phi_d_4w=(y1-y2)*chi_u_4w-k*chi_d_4w
phi_u_5w=(y1+y2)*chi_d_5w-n1*chi_u_5w/u0+chi_u_6w
phi_d_5w=(y1-y2)*chi_u_5w-n1*chi_d_5w/u0+chi_d_6w
phi_u_6w=(y1+y2)*chi_d_6w-n1*chi_u_6w/u0+2*chi_u_7w
phi_d_6w=(y1-y2)*chi_u_6w-n1*chi_d_6w/u0+2*chi_d_7w
phi_u_7w=(y1+y2)*chi_d_7w-n1*chi_u_7w/u0
phi_d_7w=(y1-y2)*chi_u_7w-n1*chi_d_7w/u0

P_u_3w=phi_u_3w/(4*k) ; P_u_1w=(phi_u_1w-2*P_u_3w)/(2*k)
P_d_3w=phi_d_3w/(4*k) ; P_d_1w=(phi_d_1w-2*P_d_3w)/(2*k)
P_u_4w=-phi_u_4w/(4*k) ; P_u_2w=-(phi_u_2w-2*P_u_4w)/(2*k)
P_d_4w=-phi_d_4w/(4*k) ; P_d_2w=-(phi_d_2w-2*P_d_4w)/(2*k)
P_u_7w=(u0*u0*phi_u_7w)/(n1**2-u0*u0*k*k)
P_u_6w=(u0*u0*phi_u_6w+4*u0*n1*P_u_7w)/(n1**2-u0*u0*k*k)
P_u_5w=(u0*u0*phi_u_5w+2*u0*n1*P_u_6w-2*u0*u0*P_u_7w)/(n1**2-u0*u0*k*k)
P_d_7w=(u0*u0*phi_d_7w)/(n1**2-u0*u0*k*k)
P_d_6w=(u0*u0*phi_d_6w+4*u0*n1*P_d_7w)/(n1**2-u0*u0*k*k)
P_d_5w=(u0*u0*phi_d_5w+2*u0*n1*P_d_6w-2*u0*u0*P_d_7w)/(n1**2-u0*u0*k*k)

X_1w=(chi_d_1w-P_d_1w)/(2*k) ; Y_1w=(chi_d_2w-P_d_2w)/(2*k)
eta_u_1w=(P_u_1w+P_d_1w)/2 ; eta_d_1w=(P_u_1w-P_d_1w)/2
eta_u_2w=(P_u_2w+P_d_2w)/2 ; eta_d_2w=(P_u_2w-P_d_2w)/2
eta_u_3w=(P_u_3w+P_d_3w)/2 ; eta_d_3w=(P_u_3w-P_d_3w)/2
eta_u_4w=(P_u_4w+P_d_4w)/2 ; eta_d_4w=(P_u_4w-P_d_4w)/2
eta_u_5w=(P_u_5w+P_d_5w)/2 ; eta_d_5w=(P_u_5w-P_d_5w)/2
eta_u_6w=(P_u_6w+P_d_6w)/2 ; eta_d_6w=(P_u_6w-P_d_6w)/2
eta_u_7w=(P_u_7w+P_d_7w)/2 ; eta_d_7w=(P_u_7w-P_d_7w)/2

C_11w=(-(alpha_d-rr*alpha_u)*(X_1w*mm2-Y_1w-eta_d_5w)*mm2+alpha_u*&
&     (-(rr+1)*X_1w+(rr+1)*Y_1w*mm2+(rr*eta_d_1w-eta_u_1w)*t0&
&     +(rr*eta_d_2w-eta_u_2w)*t0*mm2+(rr*eta_d_3w-eta_u_3w)*t0*t0&
&     +(rr*eta_d_4w-eta_u_4w)*t0*t0*mm2+(rr*eta_d_5w-eta_u_5w)*mm1&
&     +(rr*eta_d_6w-eta_u_6w)*t0*mm1+(rr*eta_d_7w-eta_u_7w)*t0*t0*mm1&
&     ))/(alpha_u*(alpha_u-rr*alpha_d)-alpha_d*(alpha_d-rr*alpha_u)*mm2*mm2)
C_21w=(X_1w*mm2-Y_1w-eta_d_5w-alpha_d*C_11w*mm2)/alpha_u
D_u_1w=alpha_u*C_11w+X_1w ; D_d_1w=alpha_d*C_11w-X_1w
D_u_2w=alpha_d*C_21w-Y_1w ; D_d_2w=alpha_u*C_21w+Y_1w

fuu1w(1)=D_u_1w*mm2+D_u_2w+eta_u_5w
fdu1w(2)=D_d_1w+D_d_2w*mm2+eta_d_1w*t0+eta_d_2w*t0*mm2+eta_d_3w*t0*t0&
&        +eta_d_4w*t0*t0*mm2+eta_d_5w*mm1+eta_d_6w*t0*mm1+eta_d_7w*t0*t0*mm1
endif
!ccccccccccccccccccccccccccccsigmag方程解cccccccccccccccccccccccccccccccccccccc
if ( sigmag .ne. 0 ) then
y_1g=-0.75*(1-ff)*ww1 ; y_2g=y_1g
y_u_5g=-0.75*(1-ff)*u0*pi*f0*ww1 ; y_d_5g=-y_u_5g

chi_u_1g=(y_1g+y_2g)*t0*(alpha_d-alpha_u)*C_10/2.
chi_d_1g=(y_2g-y_1g)*t0*(alpha_d+alpha_u)*C_10/2.
chi_u_2g=(y_1g+y_2g)*t0*(alpha_u-alpha_d)*C_20/2.
chi_d_2g=(y_2g-y_1g)*t0*(alpha_u+alpha_d)*C_20/2.
chi_u_3g=(y_1g+y_2g)*(alpha_u-alpha_d)*C_10
chi_d_3g=(y_1g-y_2g)*(alpha_u+alpha_d)*C_10
chi_u_4g=(y_1g+y_2g)*(alpha_d-alpha_u)*C_20
chi_d_4g=(y_1g-y_2g)*(alpha_d+alpha_u)*C_20
chi_u_5g=(y_1g+y_2g)*t0*(G_d_1-G_u_1)/2.+(y_u_5g-y_d_5g)*t0/2.
chi_d_5g=(y_2g-y_1g)*t0*(G_d_1+G_u_1)/2.+(y_u_5g+y_d_5g)*t0/2.
chi_u_6g=(y_1g+y_2g)*(G_u_1-G_d_1)-(y_u_5g-y_d_5g)
chi_d_6g=(y_1g-y_2g)*(G_u_1+G_d_1)-(y_u_5g+y_d_5g)

phi_u_1g=(y1+y2)*chi_d_1g+k*chi_u_1g+chi_u_3g
phi_d_1g=(y1-y2)*chi_u_1g+k*chi_d_1g+chi_d_3g
phi_u_2g=(y1+y2)*chi_d_2g-k*chi_u_2g+chi_u_4g
phi_d_2g=(y1-y2)*chi_u_2g-k*chi_d_2g+chi_d_4g
phi_u_3g=(y1+y2)*chi_d_3g+k*chi_u_3g
phi_d_3g=(y1-y2)*chi_u_3g+k*chi_d_3g
phi_u_4g=(y1+y2)*chi_d_4g-k*chi_u_4g
phi_d_4g=(y1-y2)*chi_u_4g-k*chi_d_4g
phi_u_5g=(y1+y2)*chi_d_5g-n1*chi_u_5g/u0+chi_u_6g
phi_d_5g=(y1-y2)*chi_u_5g-n1*chi_d_5g/u0+chi_d_6g
phi_u_6g=(y1+y2)*chi_d_6g-n1*chi_u_6g/u0
phi_d_6g=(y1-y2)*chi_u_6g-n1*chi_d_6g/u0

P_u_3g=phi_u_3g/(4*k) ; P_u_1g=(phi_u_1g-2*P_u_3g)/(2*k)
P_d_3g=phi_d_3g/(4*k) ; P_d_1g=(phi_d_1g-2*P_d_3g)/(2*k)
P_u_4g=-phi_u_4g/(4*k) ; P_u_2g=-(phi_u_2g-2*P_u_4g)/(2*k)
P_d_4g=-phi_d_4g/(4*k) ; P_d_2g=-(phi_d_2g-2*P_d_4g)/(2*k)
P_u_6g=u0*u0*phi_u_6g/(n1**2-u0*u0*k*k)
P_u_5g=(u0*u0*phi_u_5g+2*u0*n1*P_u_6g)/(n1**2-u0*u0*k*k)
P_d_6g=u0*u0*phi_d_6g/(n1**2-u0*u0*k*k)
P_d_5g=(u0*u0*phi_d_5g+2*u0*n1*P_d_6g)/(n1**2-u0*u0*k*k)

X_1g=(chi_d_1g-P_d_1g)/(2*k) ; Y_1g=(chi_d_2g-P_d_2g)/(2*k)
eta_u_1g=(P_u_1g+P_d_1g)/2 ; eta_d_1g=(P_u_1g-P_d_1g)/2
eta_u_2g=(P_u_2g+P_d_2g)/2 ; eta_d_2g=(P_u_2g-P_d_2g)/2
eta_u_3g=(P_u_3g+P_d_3g)/2 ; eta_d_3g=(P_u_3g-P_d_3g)/2
eta_u_4g=(P_u_4g+P_d_4g)/2 ; eta_d_4g=(P_u_4g-P_d_4g)/2
eta_u_5g=(P_u_5g+P_d_5g)/2 ; eta_d_5g=(P_u_5g-P_d_5g)/2
eta_u_6g=(P_u_6g+P_d_6g)/2 ; eta_d_6g=(P_u_6g-P_d_6g)/2

C_11g=(-(alpha_d-rr*alpha_u)*(X_1g*mm2-Y_1g-eta_d_5g)*mm2+alpha_u*&
&     (-(rr+1)*X_1g+(rr+1)*Y_1g*mm2+(rr*eta_d_1g-eta_u_1g)*t0&
&     +(rr*eta_d_2g-eta_u_2g)*t0*mm2+(rr*eta_d_3g-eta_u_3g)*t0*t0&
&     +(rr*eta_d_4g-eta_u_4g)*t0*t0*mm2+(rr*eta_d_5g-eta_u_5g)*mm1&
&     +(rr*eta_d_6g-eta_u_6g)*t0*mm1))/(alpha_u*(alpha_u-rr*alpha_d)&
&     -alpha_d*(alpha_d-rr*alpha_u)*mm2*mm2)
C_21g=(X_1g*mm2-Y_1g-eta_d_5g-alpha_d*C_11g*mm2)/alpha_u
D_u_1g=alpha_u*C_11g+X_1g ; D_d_1g=alpha_d*C_11g-X_1g
D_u_2g=alpha_d*C_21g-Y_1g ; D_d_2g=alpha_u*C_21g+Y_1g

fuu1g(1)=D_u_1g*mm2+D_u_2g+eta_u_5g
fdu1g(2)=D_d_1g+D_d_2g*mm2+eta_d_1g*t0+eta_d_2g*t0*mm2+eta_d_3g*t0*t0&
&        +eta_d_4g*t0*t0*mm2+eta_d_5g*mm1+eta_d_6g*t0*mm1
end if
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
fuu(1)=fuu1(1)+sigmaw*fuu1w(1)+sigmag1*fuu1g(1)
fdu(2)=fdu1(2)+sigmaw*fdu1w(2)+sigmag1*fdu1g(2)
fdu(1)=fdu(1)+u0*pi*f0
fdu(2)=fdu(2)+u0*pi*f0*mm1

TI0=fuu(1)/(2*pi*pi)
TI1=fuu(1)/(4*pi*pi)

!open(12,file="mu256.txt")
!open(111,file="I_u.txt")
!do 1001 i=1,90
!read(12,*)  mu(i)
!zmu=mu(i)
!PP1=zmu
!PP2=0.5*(3*zmu**2-1)
!PP3=0.5*(5*zmu**3-3*zmu)
!AP1=-6.210782379474913*u0+5.783227630015377  ; BP1=-2.761103001625419*u0+0.993681514943675
!AP2=-3.054554127360934*u0+4.474765546640607  ; BP2=2.143685150869431*u0-0.129630387218231
!AP3=0.019880783686420*u0+0.159300336219902   ; BP3=-0.589317041597288+0.985180986451162
!AP4=-5.320711000050651*u0+14.226748298111872 ; BP4=0.636797921641261*u0-0.211448936708153
!AP5=-0.300290008968647*u0+1.042440506457924  ; BP5=-0.080448737918686*u0+0.190493965417525
!A2=AP1+AP2*exp(-AP3*t0)+AP4*exp(-AP5*t0)
!B2=BP1+BP2*exp(-BP3*t0)+BP4*exp(-BP5*t0)
!TI=TI0+(3*PP1-sqrt(3.)*(4./15)*A2*(PP2-B2*PP3)+sqrt(3.)*A2*(1-zmu)**4)*TI1
!write(111,*) TI
!1001 end do
!close(12)


PP1=u
PP2=0.5*(3*u**2-1)
PP3=0.5*(5*u**3-3*u)
AP1=-6.210782379474913*u0+5.783227630015377  ; BP1=-2.761103001625419*u0+0.993681514943675
AP2=-3.054554127360934*u0+4.474765546640607  ; BP2=2.143685150869431*u0-0.129630387218231
AP3=0.019880783686420*u0+0.159300336219902   ; BP3=-0.589317041597288*u0+0.985180986451162
AP4=-5.320711000050651*u0+14.226748298111872 ; BP4=0.636797921641261*u0-0.211448936708153
AP5=-0.300290008968647*u0+1.042440506457924  ; BP5=-0.080448737918686*u0+0.190493965417525
A2=AP1+AP2*exp(-AP3*t0)+AP4*exp(-AP5*t0)
B2=BP1+BP2*exp(-BP3*t0)+BP4*exp(-BP5*t0)
TI=TI0+(3*PP1-sqrt(3.)*(4./15)*A2*(PP2-B2*PP3)+sqrt(3.)*A2*(1-u)**4)*TI1
mm3=exp(-t0/u)
open(100,file="I_phi.txt")
Do Del_varph = 0.0, pi*1.00001, pi/180.0
!cccccccccccccccccccccccccccc方位角平均单次散射近似cccccccccccccccccccccccccccccccccccccccccccccccccccccccc
TI_Rid_ref_a=u0*f0*ww1/(4*pi*u+4*pi*u0)*(1-3*g1*u*u0)*(1-mm3*mm1)
mm4=u*u0/(u+u0)
mm5=-mm4*(t0*mm1*mm3-mm4*(1-mm1*mm3))-t0/2*mm4*(1-mm1*mm3)
if ( sigmaw*sigmag .ne. 0. ) then
TI_Rid_ref_b=f0/(4*pi*u)*(1-3*g1*u*u0)*sigmaw*mm5
TI_Rid_ref_c=3*ww1*f0/(4*pi*u)*u*(-u0)*sigmag*mm5
end if
TI_Rid_ref=TI_Rid_ref_a+TI_Rid_ref_b+TI_Rid_ref_c
!cccccccccccccccccccccccccccc方位角单次散射近似cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
A_n=0.0
B_n=0.0
Co_ta =  -1 * u * u0 + (1-u ** 2 ) ** 0.5 * (1-u0 ** 2) ** 0.5 * cos (Del_varph)
p(1)=1
p(2)=Co_ta
do uj=3,257
p(uj)=((2*uj-3)*p(uj-1)*Co_ta-(uj-2)*p(uj-2))/(uj-1)
end do
do uj=1,256
A_n=A_n+(2*uj+1)*(g1**(uj))*p(uj+1)
B_n=B_n+uj*(2*uj+1)*(g1**(uj-1))*p(uj+1)
end do
TI_Rid_ref_azi_a=ww1*u0*f0/(4*pi*u+4*pi*u0)*(1+A_n)*(1-mm1*mm3)
if ( sigmaw*sigmag .ne. 0. ) then
TI_Rid_ref_azi_b=f0/(4*pi*u)*(1+A_n)*sigmaw*mm5
TI_Rid_ref_azi_c=ww1*f0*B_n/(4*pi*u)*sigmag*mm5
end if
TI_Rid_ref_azi=TI_Rid_ref_azi_a+TI_Rid_ref_azi_b+TI_Rid_ref_azi_c
A1=1.37274716700257+2.28314293808216*exp(-0.239990560495366*t0)+0.19697643212208*exp(-0.067682028058161*t0)
B1=0.264792594110793+0.140143699687255*exp(-0.111634491547954*t0)+0.602420275947837*exp(-0.396812625790932*t0)
C1=0.054475256739328+0.155652641953867*exp(-0.544394885750421*t0)+0.041887090060518*exp(-0.132092055958015*t0)
D1=0.011126489523445+0.031462918416751*exp(-0.333210507772807*t0)+0.007460670419532*exp(-0.115212836330081*t0)
TI_AZI=TI_Rid_ref_azi-TI_Rid_ref+TI&
&      +A1*(1-u)*(1-u0)*TI*cos(Del_varph)&
&      +B1*(1-u)*(1-u0)*TI*cos(2*Del_varph)&
&	   +C1*(1-u)*(1-u0)*TI*cos(3*Del_varph)&
&	   +D1*(1-u)*(1-u0)*TI*cos(4*Del_varph)
write( 100 , * ) TI_AZI
end do
!cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

!open(6,file='eddtingtonre.txt')
!open(8,file='eddtingtontr.txt')
!open(10,file='eddtingtonab.txt')
!write(6,*) fuu(1)/fdu(1)
!write(8,*) fdu(2)/fdu(1)
!write(10,*) 1-(fuu(1)/fdu(1))-(fdu(2)/fdu(1))

!open(16,file='re_homogeneous.txt')
!open(18,file='tr_homogeneous.txt')
!open(20,file='ab_homogeneous.txt')
!write(16,*) fuu1(1)/(fdu1(1)+u0*pi*f0)
!write(18,*) (fdu1(2)+u0*pi*f0*mm1)/(fdu1(1)+u0*pi*f0)
!write(20,*) 1-fuu1(1)/(fdu1(1)+u0*pi*f0)-(fdu1(2)+u0*pi*f0*mm1)/(fdu1(1)+u0*pi*f0)
!2000 enddo
!3000 enddo
end