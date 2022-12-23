import xarray as xr


grid='tx1_4v1'


gfile='/glade/work/fredc/cesm/grid/MOM6/{}/gridgen/ocean_hgrid.nc'.format(grid)
ds = xr.open_dataset(gfile)

ds_trim = ds.copy().drop_dims(['nyp', 'nxp', 'ny', 'nx'])


if grid == 'tx1_4v1':
    nyp=2161
    ny=2160

for varname in list(ds):
    if 'nyp' in(ds[varname].dims):
        ds_trim[varname] = ds[varname][-nyp:,:]
    elif 'ny' in(ds[varname].dims):
        ds_trim[varname] = ds[varname][-ny:,:]


encoding = {'y': {'_FillValue': None},
            'x': {'_FillValue': None},
            'dy': {'_FillValue': None},
            'dx': {'_FillValue': None},
            'area': {'_FillValue': None},
            'angle_dx': {'_FillValue': None},
           }


tgfile='/glade/work/fredc/cesm/grid/MOM6/{}/gridgen/ocean_hgrid_trimmed.nc'.format(grid)
ds_trim.to_netcdf(tgfile, encoding=encoding)

