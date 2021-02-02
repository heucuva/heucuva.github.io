---
layout: post
title:  "Mixing with Surround Channel"
date:   2021-01-30 06:55:00 -0800
categories: audio gotracker
---
While building my tracked music player that's written in Go, [Gotracker][gotracker-gh], I noticed that a few formats referred to Surround Sound (specifically, Dolby Pro Logic II). I remember researching how to achieve Pro Logic surround sound encoding a few decades ago, but I didn't recall how to achieve it in source code. Apparently, it's really simple - like, extremely so... or so the Internet would have you believe at first glance.

When you go to do your final mix before heading the audio data out to the sound device, you take your surround channel and mix it into the left channel with a +90&deg; phase and the right channel with a -90&deg; phase. However, it's not exactly as simple as that.

Here's the full process, in brief:
1. The Surround channel is a monaural channel that does not link to any other channels via positional variation - cross-fading with the surround channel might not do what you expect.
2. Before it heads into the bandpass filter in step 3, it needs a -3dB attenuation.
3. A bandpass filter is applied that excludes frequences outside the range between 100Hz and 7000Hz, inclusively.
4. A Dolby `B-type` noise reduction (or compatible, such as dbx) filter is applied.
5. The result of step 4 is split into two channels, a left at +90&deg; phase shift and a right at -90&deg; phase shift.
6. The final mix occurs with the result of step 5.

In order to be 100% compatible with Pro Logic II, step 4 can't be bypassed. It reduces the fidelity of the audio pretty badly, but it's a fact of dealing with decades-old hardware, I suppose. However, modern implementations of Pro Logic (III and newer) seem to be pretty lenient about how to detect the surround channel out of the left+right channels, so you can probably get by with not implementing the B-type NR and only sometimes get bleed-through of surround audio in the left/right forward channels.

In the process of researching how to write my own, I came across some code that [Derek J. Evans][dje-email] wrote for a Reaper JS plugin that takes a quad-channel output and generates a Pro Logic II-compatible downmix to stereo - seems pretty much right on the money for my needs:

```javascript
/*
** Name: DPLII Quadrophonic Encoder
** Auth: Derek J. Evans (derek.john.evans@hotmail.com)
**
** Desc: Encodes a quadrophonic (4 channel) mix to a DPL/DPLII style stereo signal.
**       To use, place this effect after a ReaSurround (set to quadrophonic). This encoder
**       will take 4 channels (1-4) and output a stereo DPL/DPLII mix.
**       I have tested this encoder on a Kenwood Surround Receiver (KRF-V5560D) which has a licensed
**       Dolby Prologic II, DTS.   
** Note: The phase adjust was taken from "JS: Utility/phase_adjust". Great Code!
** Date: Monday, 13 January 2014
*/

desc: DPLII Quadrophonic Encoder

@init 

  fftsize = 8192; 
  pdc_bot_ch = 0;
  pdc_top_ch = 2;
  pdc_delay = fftsize;
  
  // Array Pointers
  wind = 0;
  buf0 = fftsize * 2; // Rear
  buf1 = buf0 + buf0; 
  buf2 = buf1 + buf0; // Front
  buf3 = buf2 + buf0; 
        
  pos = 0; 
  w = 2.0 * $pi / fftsize;
  i = 0;
  loop(fftsize / 2,
    wind[i] = 0.42 - 0.50 * cos(i * w) + 0.08 * cos(2.0 * i *w);
    i += 1;
  ); 
  phaseadj = $pi * 90.0 / 180.0;
  cadj = cos(phaseadj);
  sadj = sin(phaseadj);
  
  db0 = sqrt( 1 /  2);
  db1 = sqrt(19 / 25);
  db2 = sqrt( 6 / 25);
  
@sample

  pos >= fftsize ? (
    tmp = buf0; buf0 = buf1; buf1 = tmp;
    tmp = buf2; buf2 = buf3; buf3 = tmp;
            
    fft(buf0, fftsize); 
    fft_permute(buf0, fftsize);

    i = 0;
    loop(fftsize / 2, 
      a = i;
      b = a + 1;
      x = buf0[a];
      y = buf0[b];
      buf0[a] = x * cadj - y * sadj;
      buf0[b] = x * sadj + y * cadj;

      a = 2 * fftsize - i - 2;
      b = a + 1;
      x = buf0[a];
      y = buf0[b];
      buf0[a] =  x * cadj + y * sadj;
      buf0[b] = -x * sadj + y * cadj;

      i += 2;
    );

    fft_ipermute(buf0, fftsize); 
    ifft(buf0, fftsize);

    pos = 0;
  );

  w1 = wind[pos / 2];
  w2 = wind[(fftsize - pos) / 2 - 1];
  sw = (w1 + w2) * fftsize;
    
  FL = buf2[pos + 0]; // Front Left
  FR = buf2[pos + 1]; // Front Right
  RL = (buf0[pos + 0] + buf1[pos + 0 + fftsize]) / sw; // Rear Left
  RR = (buf0[pos + 1] + buf1[pos + 1 + fftsize]) / sw; // Read Right
  
  buf2[pos + 0] = spl0; // Front Left
  buf2[pos + 1] = spl1; // Front Right
          
  buf0[pos + 0] = spl2 * w1;
  buf0[pos + 1] = spl3 * w1;
  buf1[pos + 0 + fftsize] = spl2 * w2;
  buf1[pos + 1 + fftsize] = spl3 * w2;
   
  // Dolby Pro Logic II Encoding Matrix      
  spl0 = FL - RL * db1 - RR * db2; // Left Total
  spl1 = FR + RL * db2 + RR * db1; // Right Total

  pos += 2;
```

Now to convert it to Go and slot it in somehow...

[gotracker-gh]:   https://github.com/gotracker/gotracker
[dje-email]:      mailto:derek.john.evans@hotmail.com