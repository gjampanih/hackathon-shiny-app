def run():
    import numpy as np 
    from scipy import ndimage
    import pandas as pd
    from scipy.io import wavfile
    from scipy.signal import spectrogram
    import pickle
    import time
    import os
# 
#     FILE_NAMEs= ['/Users/alexwang/Downloads/pred_kegl-1.wav',
#                  '/Users/alexwang/Downloads/silencedintervals.wav']
    curr_dir = os.getcwd()
    path_parent = os.path.dirname(curr_dir)
    data_dir = path_parent + '/data'
    FILE_NAMEs= [data_dir + '/audio/pred_kegl-1.wav',
                 data_dir + '/audio/silencedintervals.wav']

    
    MODEL_DIR=data_dir + '/processed/1911_k1.pkl'

    output_dir=curr_dir #specify output dir if you want

    def db(S):
        return 10 * np.log10(S)

    def pred_pop(filename,OUTPUT_DIR=''):

        SHRINK_RATIO=0.4
        hop = 5

        model=pickle.load(open(MODEL_DIR,'rb'))

        fs,wav = wavfile.read(filename)
        nn=fs*20
        j=0
        n = 0
        startlist = []
        endlist = []
        label = []
        tm = []

        while j+nn<len(wav):
            twav = wav[j:j+nn]
            f,t,Sxx = spectrogram(twav,fs=fs,window='hann',nperseg=1024,nfft=2048,noverlap=512)
            S=db(Sxx)
            S=ndimage.zoom(S,SHRINK_RATIO)
            S-=S.min()
            S/=S.max()
            S=S.reshape((1,S.shape[0],S.shape[1],1))

            model_output = model.predict(S,verbose=0).argmax(axis=1) # make prediction here

            tm.append(j/fs)
            label.append(model_output)
            if model_output == 1:
                if not startlist:
                    startlist.append(j)
                    endlist.append(j+nn)
                    n+=1
                elif j<=endlist[-1]:
                    endlist.pop()
                    endlist.append(j+nn)
                else:
                    n+=1
                    startlist.append(j)
                    endlist.append(j+nn)
            j+=hop*fs

        # save model prediction
        df = pd.DataFrame({'starttime':tm,'prediction':label})
        outname=f'{OUTPUT_DIR}/pred.csv' if OUTPUT_DIR else 'pred.csv'
        df.to_csv(outname) # change filepath and name here

        #save start and end time of problematic pieces
        startlist = np.array(startlist)/fs
        endlist = np.array(endlist)/fs
        df2 = pd.DataFrame({'start':startlist,'end':endlist})
        outname=f'{OUTPUT_DIR}/timeidx.csv' if OUTPUT_DIR else 'timeidx.csv'
        df2.to_csv(outname) #change filepath and name here

    def ma(inv, n) :
        tmp = np.cumsum(inv, dtype=float)
        tmp[n:] = tmp[n:] - tmp[:-n]
        return tmp[n - 1:] / n

    def find_silence(filename,dur = 6,OUTPUT_DIR=''): #default 6 sec
        fs,wav = wavfile.read(filename)
        wav2 = np.array(abs(wav))
        wav2[wav2<=0.03]=0
        wav2[wav2>0.03]=1
        N=dur*fs
        wav3 = ma(wav2,N)
        label = np.where(wav3<10**-3,1,0)
        label2 = np.diff(label)
        idx = np.round(np.where(label2==1)[0]/fs,1)
        idx2 = np.round(np.where(label2==-1)[0]/fs,1)+dur
        df =pd.DataFrame({'start':idx,'end':idx2})
        outname=f'{OUTPUT_DIR}/silenceidx.csv' if OUTPUT_DIR else 'silenceidx.csv'
        df.to_csv(outname)

    st = time.time()
    find_silence(FILE_NAMEs[1],dur=6,OUTPUT_DIR=output_dir)
    et = time.time()
    dt = et-st
    #np.savetxt('testtime.csv',dt)
    st = time.time()
    pred_pop(FILE_NAMEs[0], OUTPUT_DIR=output_dir)
    et = time.time()
    dt2 = et-st
    #np.savetxt('testtime.csv',[dt,dt2])


run()
