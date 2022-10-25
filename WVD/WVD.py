import numpy as np
import matplotlib.pyplot as plt
from tftb.processing import WignerVilleDistribution
import tftb
import scipy.signal as sig

def wvd(s,t=None, Nfreq=None):
    # If not in array form yet, convert
    if type(s) != np.ndarray:
        s = np.array(s)

    # Perform assumption checks on input
    if len(np.shape(s)) > 1:
        raise ValueError('Input signal s(t) must be 1-dimensional.')

    Nt = len(s)
    if Nfreq == None:
        Nfreq = Nt

    if np.any(t) == None:
        t = np.arange(Nt)

    if Nt != len(s):
        raise ValueError('s(t) must have only 1 value per index of the array t.')

    
    # Create complex conjugate of s
    s_c = np.conj(s)


    # Start the WVD

    mesh = np.zeros((Nfreq,Nt), dtype='complex') # Create WVD mesh
    # Create an array of the maximum values the tau array can have per time index
    taumax_t = np.min(np.c_[np.arange(Nt),Nt - np.arange(Nt) - 1,(round(Nfreq/2)-1) * np.ones(Nt)], axis=1)

    for i in range(Nt): # Loop over columns
        ti = int(t[i])
        taumax = taumax_t[i]
        tau = np.arange(-taumax, taumax+1).astype(int)

        index = (Nfreq + tau) % Nfreq # Create indices on which to calculate the convolution
        mesh[index,i] = s[i+tau] * s_c[i-tau]

        # Next part of the loop is not mine! I couldn't get it working and found this online
        # Full credits go to Dr. Ing. Frank Zalkow
        tau = round(Nfreq/2)
        if ti+1 <= Nt-tau and ti >= tau + 1:
            mesh[tau, i] = s[i+tau]*s_c[i-tau] + s[i-tau]*s_c[i+tau]
    
    mesh = np.real(np.fft.fft(mesh,axis=0))
    f = 0.5*np.arange(Nfreq) / Nfreq
    return mesh, t, f








#===================================================


T = 2  # signal duration
dt = 1/500  # sample interval/spacing
freq_s = 1/dt  # sampling frequency
N = T / dt  # number of samples
ts = np.arange(N) * dt  # times

#  constructing a chirp multiplied by a Gaussian
t0 = T/2
freq = np.linspace(10, 30, int(N))
sigma = 0.1
signal = np.cos((ts-t0) * 2 * np.pi * freq) * np.exp(-(ts-t0)**2/(2*sigma**2))/np.sqrt(sigma)

# adding some noise
signal += np.random.randn(len(signal))*0.5


#  plotting the signal
plt.figure()
plt.plot(ts, signal)
plt.show()

# first looking at the power of the short time fourier transform (SFTF):
nperseg = 2**6  # window size of the STFT
f_stft, t_stft, Zxx = sig.stft(signal, freq_s, nperseg=nperseg,
                           noverlap=nperseg-1, return_onesided=False)

# shifting the frequency axis for better representation
Zxx = np.fft.fftshift(Zxx, axes=0)
f_stft = np.fft.fftshift(f_stft)

#===============================================

# Doing the WVT
tfr_wvd, t_wvd, f_wvd = wvd(signal, t=ts)
# here t_wvd is the same as our ts, and f_wvd are the "normalized frequencies"
# so we will not use them and construct our own.

f, axx = plt.subplots(2, 1)

df1 = f_stft[1] - f_stft[0]  # the frequency step
im = axx[0].imshow(np.real(Zxx * np.conj(Zxx)), aspect='auto',
          interpolation=None, origin='lower',
          extent=(ts[0] - dt/2, ts[-1] + dt/2,
                  f_stft[0] - df1/2, f_stft[-1] + df1/2))
axx[0].set_ylabel('frequency [Hz]')
plt.colorbar(im, ax=axx[0])
axx[0].set_title('Spectrogram')


# because of how they implemented WVT, the maximum frequency is half of
# the sampling Nyquist frequency, so 125 Hz instead of 250 Hz, and the sampling
# is 2 * dt instead of dt
f_wvd = np.fft.fftshift(np.fft.fftfreq(tfr_wvd.shape[0], d=2 * dt))
df_wvd = f_wvd[1]-f_wvd[0]  # the frequency step in the WVT
im = axx[1].imshow(np.fft.fftshift(tfr_wvd, axes=0), aspect='auto', origin='lower',
       extent=(ts[0] - dt/2, ts[-1] + dt/2,
               f_wvd[0]-df_wvd/2, f_wvd[-1]+df_wvd/2))
axx[1].set_xlabel('time [s]')
axx[1].set_ylabel('frequency [Hz]')
plt.colorbar(im, ax=axx[1])
axx[1].set_title('Wigner-Ville Distribution')
plt.tight_layout()
plt.show()