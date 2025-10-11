program  vibmodes
! 
integer           :: nat, iframe, nframe, i, j, l, i1, i2, i3, ix
double precision  :: frmul, lattice_car(3,3), ftmp
double precision, allocatable :: fcoo(:,:), a(:,:), coo(:,:)
character(len=2), allocatable :: cel(:)
! 
  nframe=5
  frmul =0.05
!
!  read(*,*) (lattice_car(i,1),i=1,3)
!  read(*,*) (lattice_car(i,2),i=1,3)
!  read(*,*) (lattice_car(i,3),i=1,3)
!
  read(*,*) nat, frmul
!  read(*,*)
!
  allocate( fcoo(3,nat), a(3,nat), coo(3,nat), cel(nat) )
!
  do i=1,nat
     read(*,*)cel(i), fcoo(1,i), fcoo(2,i), fcoo(3,i)
  end do
!
  read(*,*)
  read(*,*)
  do i=1,nat
     read(*,*)a(1,i), a(2,i), a(3,i)
  end do
!
  write(*,"(A)")"#!/bin/sh"
  write(*,"(A)")"# run from directory where this script is"
  write(*,"(A)")"cd `echo $0 | sed 's/\(.*\)\/.*/\1/'`"
  write(*,"(A)")"EXAMPLE_DIR=`pwd`"
  write(*,"(A)")
  write(*,"(A)")"# check whether echo has the -e option"
!  write(*,*)'if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi'
  write(*,"(A)")
  write(*,"(A)")"mkdir n1"
  write(*,"(A)")"mkdir n2"
  write(*,"(A)")"mkdir p1"
  write(*,"(A)")"mkdir p2"
  write(*,"(A)")
  write(*,"(A)")"mkdir bandderivative"
  write(*,"(A)")
  write(*,"(A)")"cp control.in n1/."
  write(*,"(A)")"cp control.in n2/."
  write(*,"(A)")"cp control.in p1/."
  write(*,"(A)")"cp control.in p2/."
  write(*,"(A)")
  write(*,"(A)")

  do l=1, 4
     if (l==1) then
        ftmp=frmul
     else if (l==2) then
        ftmp=frmul*2.0
     else if (l==3) then
        ftmp=-frmul
     else if (l==4) then
        ftmp=-frmul*2.0
     end if
!
     write(*,"(A)")"cat > geometry.in << EOF"
     write(*,"(A)")"# Geometry for BN-10Cube"
     write(*,"(A)")"# "
     write(*,"(A)")" lattice_vector       5.012954616    0.000024807    0.000000115"
     write(*,"(A)")" lattice_vector      -2.506455827    4.341358452   -0.000000115"
     write(*,"(A)")" lattice_vector       0.000000145   -0.000000085    6.336166021"
     write(*,"(A)")"# "
     write(6,"(A1,F10.6)")"#", ftmp
              do i=1, nat
                 do j=1, 3 
                    coo(j,i) = fcoo(j,i) + ftmp*a(j,i)
                 end do
                 write(*,'(A4, 3X, 3F10.6, 4X, A2)')'atom',coo(1,i),coo(2,i),coo(3,i), trim(cel(i))
              end do
     write(*,"(A)")"EOF"
     if (l==1) then
        write(*,"(A)")"mv geometry.in n1/."
     else if (l==2) then
        write(*,"(A)")"mv geometry.in n2/."
     else if (l==3) then
        write(*,"(A)")"mv geometry.in p1/."
     else if (l==4) then
        write(*,"(A)")"mv geometry.in p2/."
     end if
!
  end do
!
  write(*,"(A)")
  write(*,"(A)")"cd n1"
  write(*,"(A)")
  write(*,"(A)")"sbatch myaims-s.sh Cube-mode$1-n1"
  write(*,"(A)")
  write(*,"(A)")"sleep 10"
!  write(*,"(A)")"cat band1001.out band1002.out band1003.out band1004.out band1005.out band1006.out >>bands2.in"
!  write(*,"(A)")
!  write(*,"(A)")"mv bands2.in ../bandderivative/."
  write(*,"(A)")
  write(*,"(A)")"cd .."
  write(*,"(A)")
  write(*,"(A)")"cd n2"
  write(*,"(A)")
  write(*,"(A)")"sbatch myaims-s.sh Cube-mode$1-n2"
  write(*,"(A)")
  write(*,"(A)")"sleep 10"
!  write(*,"(A)")"cat band1001.out band1002.out band1003.out band1004.out band1005.out band1006.out  >>bands1.in"
!  write(*,"(A)")
!  write(*,"(A)")"mv bands1.in ../bandderivative/."
  write(*,"(A)")
  write(*,"(A)")"cd .."
  write(*,"(A)")
  write(*,"(A)")"cd p1"
  write(*,"(A)")
  write(*,"(A)")"sbatch myaims-s.sh  Cube-mode$1-p1"
  write(*,"(A)")
  write(*,"(A)")"sleep 10"
!  write(*,"(A)")"cat band1001.out band1002.out band1003.out band1004.out band1005.out band1006.out   >>bands4.in"
!  write(*,"(A)")
!  write(*,"(A)")"mv bands4.in ../bandderivative/."
  write(*,"(A)")
  write(*,"(A)")"cd .."
  write(*,"(A)")
  write(*,"(A)")"cd p2"
  write(*,"(A)")
  write(*,"(A)")"sbatch myaims-s.sh  Cube-mode$1-p2"
  write(*,"(A)")
  write(*,"(A)")"sleep 10"
!  write(*,"(A)")"cat band1001.out band1002.out band1003.out band1004.out band1005.out band1006.out   >>bands5.in"
!  write(*,"(A)")
!  write(*,"(A)")"mv bands5.in ../bandderivative/."
  write(*,"(A)")
  write(*,"(A)")"cd .."
  write(*,"(A)")
!
  deallocate(fcoo, a, coo, cel )
!
end program vibmodes

