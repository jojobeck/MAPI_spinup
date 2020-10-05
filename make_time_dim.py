import numpy as np

import dimarray as da
# name = 'MAR-yr-mean-1961-1990-18km.cdf'
# name = 'MAR-yr-mean-1961-1990-9km.cdf'
# name = 'MAR-yr-mean-1961-1990-4.5km.cdf'
path= '/home/beckmann/icedata/MaPi/MAR_output/'
# name = 'MAR-yr-mean-1961-1990-4.5km-2.cdf'
# name = 'MAR-yr-mean-1961-1990-18km-2.cdf'
names = [
    'MAR-yr-mean-1961-1990-9km-4.cdf',
    'MAR-yr-mean-1961-1990-18km-4.cdf',
    'MAR-yr-mean-1961-1990-4.5km-4.cdf'
]
for name in names:
    d = da.read_nc(path +name)
    smb_new= np.zeros((1,d.Y.size,d.X.size))
    st_new= np.zeros((1,d.Y.size,d.X.size))
    mm = d['SMB'].values > 9e33
    d['SMB'].values[mm] =0
    mm = d['ST'].values > 9e33
    d['ST'].values[mm] =0
    smb_new[0,:,:] = d['SMB'].values
    st_new[0,:,:] = d['ST'].values
    time=np.ones(1)

    smb = da.DimArray(smb_new.tolist(),axes=[time,d.Y,d.X],dims=['time','y','x'])

    st = da.DimArray(st_new.tolist(),axes=[time,d.Y,d.X],dims=['time','y','x'])
    ds = da.Dataset(SMB=smb,ST=st) 
    ds.write_nc(name.split('.cdf')[0]+'_time.nc')

