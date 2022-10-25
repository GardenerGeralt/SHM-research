import numpy as np
from scipy.fft import fft, ifft, fftfreq
import matplotlib.pyplot as plt
from scipy.signal import hilbert

''' 
The Hilbert Transform is a R->R operator that is a convolution with:

  1
------
pi * t

Which has the simple effect of shifting frequency components by 90 degrees 
if they are positive and by -90 degrees if they are negative.

Furthermore, it has the property of returning the original function when
applied twice due to the above property. (i.e. H(H(u))(t) = -u(t)))

However, this convolution has an issue of not always being able to 
converge. As such, the full definition is written as:

H(u)(t) = (-1/pi) lim m->0 Integral of (u(t+tau) - u(t-tau))/tau dtau from m to inf

---------------------------------

This definition is not amazing to work with in programming, though.
This is due to to the integration to infinity, which must instead be
approached until sufficient convergence is reached. Due to the fact that
this differs from function to function, it is instead chosen to work in
the Fourier domain, where the Fourier-transformed Hilbert Transform simply
becomes:

F(H(u))(w) = -j*sgn(w)*F(u)(w)

where j = sqrt(-1) and sgn is the sign function.

Because the Fourier transform is extremely well optimized within the field
of data analysis, it is much preferred to work with this method due to its
much superior speed and precision.

However, let's take a small step back and look at what this is doing. 
Because of the symmetry property of the Fourier transform of a real
function(which is a requirement of the input function for HT) all this is
doing is doubling the result of either the negative or positive frequencies,
allowing for the halving of the computational cost by simply multiplying 
one of either sides by 2.

However, this is not even the cheapest we can get it. As it turns out,
it is possible to skip the somewhat more computationally expensive process
of multiplying complex numbers by ignoring the multiplication by j and 
instead taking the imaginary component of the ifft, which is the same as
the regular Hilbert transform.

An example code of this method is displayed below, along with explanation 
of its steps.
'''


def hilberttransform(x):
    if np.iscomplexobj(x): # x must be a purely real function
        raise ValueError('x must be real.')

    Xf = fft(x) # Generate the FFT of x

    N = len(x)
    xu = np.zeros(N) # Generate an array of 0s which will become the multipliers

    if N % 2 == 0:
        xu[0 : N//2 + 1] = 2 # Doubling the first half of frequencies while cancelling out the other half
    else:
        xu[0 : N//2 + 1] = 2
        xu[N//2] = 1 # Same as with N is even, but since N//2 represents 0 here it must stay at 1(No other half)

    return ifft(xu*Xf) 


t = np.linspace(-10,10,1000)
x = np.sin(t)/t

ht = np.imag(hilberttransform(x)) # Should return the function (1-cos(t))/t
ht_builtin = np.imag(hilbert(x))
ht_theoretical = (1-np.cos(t))/t

fig, axs = plt.subplots(3, sharex=True)
axs[0].plot(t, ht)
axs[0].set_title('Custom-built Hilbert transform')
axs[1].plot(t, ht_theoretical)
axs[1].set_title('Actual Hilbert transform')
axs[2].plot(t, ht-ht_theoretical)
axs[2].set_title('Absolute error')
plt.tight_layout()
plt.show()

# fig, axs = plt.subplots(3, sharex=True)
# axs[0].plot(t, ht)
# axs[0].set_title('Custom-built Hilbert transform')
# axs[1].plot(t, ht_builtin)
# axs[1].set_title('Premade Hilbert transform')
# axs[2].plot(t, ht-ht_builtin)
# axs[2].set_title('Absolute error')
# plt.tight_layout()
# plt.show()