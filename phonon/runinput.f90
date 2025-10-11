program  vibmodes
! 
integer           :: nat, iframe, nframe, i, j, l, i1, i2, i3, ix
double precision  :: frmul, lattice_car(3,3), ftmp
double precision, allocatable :: fcoo(:,:), a(:,:), coo(:,:)
character(len=2), allocatable :: cel(:)
character(len=4)  :: md
! 
  nframe=5
  frmul =0.01
!
!  read(*,*) (lattice_car(i,1),i=1,3)
!  read(*,*) (lattice_car(i,2),i=1,3)
!  read(*,*) (lattice_car(i,3),i=1,3)
!
  read(*,*) nat, frmul
!  write(*,*)'frmul == ', frmul
!
  allocate( fcoo(3,nat), a(3,nat), coo(3,nat), cel(nat) )
!
  do i=1,nat
     read(*,*)cel(i), fcoo(1,i), fcoo(2,i), fcoo(3,i)
  end do
!
!  read(*,*)
!  read(*,*)
!  do i=1,nat
!     read(*,*)a(1,i), a(2,i), a(3,i)
!  end do
!
  write(*,"(A)")"#!/bin/sh"
  write(*,"(A)")"# run from directory where this script is"
  write(*,"(A)")"cd `echo $0 | sed 's/\(.*\)\/.*/\1/'`"
  write(*,"(A)")"EXAMPLE_DIR=`pwd`"
  write(*,"(A)")
  write(*,"(A)")"# check whether echo has the -e option"
!  write(*,*)'if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi'
  write(*,"(A)")
  do i=1, nat*3
!
     if (i.lt.10) then
        write(md,'(A1,I1)')"m",i
        write(*,"(A5, 1X, A2)")"mkdir",md
        write(*,"(A2, 1X, A10, 1X, A2, A2)")"cp", "control.in", md, "/."
        write(*,"(A2, 1X, A2)")"cd", md
     end if
     if (i.ge.10.and.i.lt.100) then
        write(md,'(A1,I2)')"m",i
        write(*,"(A5, 1X, A3)")"mkdir",md
        write(*,"(A2, 1X, A10, 1X, A3, A2)")"cp", "control.in", md, "/."
        write(*,"(A2, 1X, A3)")"cd", md             
     end if
     if (i.ge.100) then
        write(md,'(A1,I3)')"m",i
        write(*,"(A5, 1X, A4)")"mkdir",md
        write(*,"(A2, 1X, A10, 1X, A4, A2)")"cp", "control.in", md, "/."
        write(*,"(A2, 1X, A4)")"cd", md             
     end if
!
!     write(*,"(A5, 1X, A)")"mkdir",trim(md)
!     write(*,"(A2, 1X, A10, 1X, A, A2)")"cp", "control.in", trim(md), "/."
!     write(*,"(A2, 1X, A)")"cd", trim(md)
     write(*,"(A)")"cat >input.dat <<EOF"
     write(*,"(I4, 2X, F5.3)")nat, frmul
     do j=1, nat
        write(*,"(3X, A2, 5X, 3F14.6)") cel(j), fcoo(1,j), fcoo(2,j), fcoo(3,j)
     end do
     write(*,"(A)")"[FR-NORM-COORD]"
     write(*,"(1X,A9, 4X, I4)")"vibration", i
!    
     if (i==1) then
        read(*,"(A)")
        read(*,"(A)")
     else
        read(*,"(A)")
     end if
!
     do j=1, nat
        read(*,*) a(1,j), a(2,j), a(3,j)
     end do
!
     do j=1, nat
        write(*,"(3F10.5)")a(1,j), a(2,j), a(3,j)
     end do
     write(*,"(A)")"EOF"
     write(*,"(A)")"../bandvibmodesLaH10.x<input.dat>run"
     write(*,"(A)")"chmod +x run"
     write(*,"(A)")"cd .."
  end do
!
  deallocate(fcoo, a, coo, cel )
!
end program vibmodes

