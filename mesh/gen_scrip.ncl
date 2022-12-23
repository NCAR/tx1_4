; gen_scrip.ncl :

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
setvalues NhlGetWorkspaceObjectId()
        "wsMaximumSize" : 100000000000
end setvalues

begin
;---Input files
    ncGrdFilePath = "tx1_4_grid.nc"
    maskFilePath  = "../topography/topo_tx1_4v1_SRTM15_V2.4_S0.5.nc"

;---Output files
    dstGridPath = "tx1_4_SCRIP_221216.nc"

;----------------------------------------------------------------------
; Convert destination grid to a SCRIP convention file.
;----------------------------------------------------------------------
    mom6_grd_file = addfile(ncGrdFilePath,"r")
    tlon     = mom6_grd_file->tlon(:,:)
    tlat     = mom6_grd_file->tlat(:,:)

    Opt                = True
    Opt@ForceOverwrite = True
    Opt@PrintTimings   = True
    Opt@NetCDFType     = "netcdf4"
    Opt@Title          = "Global 1/4 degree MOM6 grid"


    ; Corners' lat lon --------------------------------------------------

    grid_dimsizes = getfiledimsizes(mom6_grd_file)
    nyp = grid_dimsizes(0)
    nxp = grid_dimsizes(1)
    ny = grid_dimsizes(2)
    nx = grid_dimsizes(3)
    n = nx*ny

    Opt@GridCornerLat = new(4*n,double)
    Opt@GridCornerLon = new(4*n,double)

    do j=0,ny-1
      do i=0,nx-1
        bi = (j*nx+i)*4 ; index of 1st corner in cell

        Opt@GridCornerLat(bi)   = mom6_grd_file->qlat(j,i)
        Opt@GridCornerLat(bi+1) = mom6_grd_file->qlat(j,i+1)
        Opt@GridCornerLat(bi+2) = mom6_grd_file->qlat(j+1,i+1)
        Opt@GridCornerLat(bi+3) = mom6_grd_file->qlat(j+1,i)
        Opt@GridCornerLon(bi)   = mom6_grd_file->qlon(j,i)
        Opt@GridCornerLon(bi+1) = mom6_grd_file->qlon(j,i+1)
        Opt@GridCornerLon(bi+2) = mom6_grd_file->qlon(j+1,i+1)
        Opt@GridCornerLon(bi+3) = mom6_grd_file->qlon(j+1,i)
      end do
    end do

    ; Mask --------------------------------------------------

    maskFile = addfile(maskFilePath,"r")
    Opt@GridMask = toint(maskFile->mask)

    ; Generate the script file ------------------------------

    curvilinear_to_SCRIP(dstGridPath,tlat,tlon,Opt)

;---Clean up
    delete(Opt)

    ; Append Area to SCRIP file------------------------------

    scripFile = addfile(dstGridPath,"w")

    grid_size = dimsizes(scripFile->grid_center_lat)
    grid_area = new(grid_size,double)
    grid_area!0 = "grid_size"

    do i=0,grid_size-1
      temp_tlat = (/ scripFile->grid_corner_lat(i,2), \
                scripFile->grid_corner_lat(i,1), \
                scripFile->grid_corner_lat(i,0), \
                scripFile->grid_corner_lat(i,3)    /)
      temp_tlon = (/ scripFile->grid_corner_lon(i,2), \
                scripFile->grid_corner_lon(i,1), \
                scripFile->grid_corner_lon(i,0), \
                scripFile->grid_corner_lon(i,3)    /)

      grid_area(i) = area_poly_sphere(temp_tlat, temp_tlon, 1)

    end do

    scripFile->grid_area = grid_area


end
