; gen_cice_gridfiles.ncl

; Input/Output File Paths:
; ===================================================================

; Input Vertical Grid File:
in_vgridPath      = "/glade/p/cesmdata/cseg/inputdata/ocn/mom/tx0.66v1/vgrid_65L_20200626_nc4.nc"

; Input Topography File:
in_topoPath       = "../topography/topo.tx1_4v1.SRTM15_V2.4.SmL0.5_C1.0.nc"

; Input Horizontal Grid File:
in_superGridPath  = "../mesh/tx1_4_grid.nc"

; Output Horizontal Grid File (binary):
out_hgridPath     = "horiz_grid_20221219.ieeer8"

; Output Topography file (binary):
out_topoPath      = "topography_20221219.ieeei4"

; ===================================================================

in_vgridFile = addfile(in_vgridPath,"r")
in_topoFile = addfile(in_topoPath,"r")
in_superGridFile = addfile(in_superGridPath,"r")

sizes = dimsizes(in_topoFile->depth)
ny = sizes(0)
nx = sizes(1)

vgridSizes = dimsizes(in_vgridFile->dz)
ndepth = vgridSizes(0)
depths = new(ndepth, double)

depths(0) = in_vgridFile->dz(0)
do k=1,ndepth-1
  depths(k) = in_vgridFile->dz(k) + depths(k-1)
end do

; fill in kmt:
kmt = new((/ny,nx/), integer)
kmt = ndepth
kmt!0 = "ny"
kmt!1 = "nx"

msk = toint(in_topoFile->mask)

do j=0,ny-1
  do i=0,nx-1
    do k=0,ndepth-1
      if (in_topoFile->depth(j,i) .lt. depths(k))
        kmt(j,i) = k
        if ( msk(j,i).lt.1 .and. kmt(j,i).gt.0 ) then
          print(" "+j+" "+i+" "+in_topoFile->depth(j,i)+" "+depths(k)+" "+(k-1) )
        end if
        break
      end if
    end do
  end do
end do

dtr = get_d2r("double")
PI  = get_pi("double")

ulat = dtr * in_superGridFile->qlat(1:ny,1:nx)
ulon = dtr * in_superGridFile->qlon(1:ny,1:nx)
htn = (in_superGridFile->dxCv) * 100.0 ; convert to cm
hte = (in_superGridFile->dyCu) * 100.0 ; convert to cm
hus = (in_superGridFile->dxCu) * 100.0 ; convert to cm
huw = (in_superGridFile->dyCv) * 100.0 ; convert to cm
angle = dtr * (in_superGridFile->angle)

print(" "+max(htn)+" "+min(htn))
print(" "+max(hte)+" "+min(hte))

; write the topography file
setfileoption("bin","WriteByteOrder","BigEndian")
system("/bin/rm -f " + out_topoPath)
fbindirwrite(out_topoPath, (kmt))

; write the horizontal grid file
system("/bin/rm -f " + out_hgridPath)
fbindirwrite(out_hgridPath, (ulat))
fbindirwrite(out_hgridPath, (ulon))
fbindirwrite(out_hgridPath, (htn))
fbindirwrite(out_hgridPath, (hte))
fbindirwrite(out_hgridPath, (hus))
fbindirwrite(out_hgridPath, (huw))
fbindirwrite(out_hgridPath, (angle))

