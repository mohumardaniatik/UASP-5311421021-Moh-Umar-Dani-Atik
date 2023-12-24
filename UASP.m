load('sinyal_diskrit1');

N = length(xn);
t = 0:N-1;

figure(1);
stem(t, xn);
xlabel('n (Waktu)');
ylabel('Amplitudo');
title('Plot Sinyal Diskrit dalam Domain Waktu');

f = (0:N-1) * (100000/N);
X = fft(xn);

figure(2);
stem(f, abs(X));
xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Spektrum Frekuensi Sinyal Diskrit');

[peaks, idx] = findpeaks(abs(X), 'SortStr', 'descend');
threshold = 0.1 * max(peaks);
significant_peaks = sum(peaks > threshold);

fprintf('Jumlah Sinyal Diskrit Dominan: %d\n', significant_peaks);

fprintf('Frekuensi dan Letak Puncak Dominan:\n');
for i = 1:significant_peaks
    fprintf('Puncak %d: Frekuensi %.2f Hz, Letak %d\n', i, f(idx(i)), idx(i));
end

figure(3);
stem(f, abs(X));
hold on;
plot(f(idx(1:significant_peaks)), abs(X(idx(1:significant_peaks))), 'ro', 'MarkerSize', 10);
hold off;

xlabel('Frekuensi (Hz)');
ylabel('Amplitudo');
title('Spektrum Frekuensi Sinyal Diskrit dengan Puncak Dominan');

Fs = 100000; 
f_pass = 20000;
f_stop = 30000; 
A_pass = 0.5; 
A_stop = 60; 

filter_lengths = [3, 9, 17, 25];

for i = 1:length(filter_lengths)
    M = filter_lengths(i);
    
    h = fir1(M-1, [f_pass, f_stop]/(Fs/2), 'high', blackman(M));
    
    disp(['Koefisien Filter untuk M = ' num2str(M)]);
    disp(round(h, 4));
    
    disp(['Fungsi Alih (Transfer Function) untuk M = ' num2str(M)]);
    disp(['H(z) = ' sprintf('%+.4f ', h)]);
    
    disp(['Persamaan Perbedaan (Difference Equation) untuk M = ' num2str(M)]);
    disp(['H(z) = ' sprintf('%+.4f * z^(-1) + ', h(1:end-1)) ' ' sprintf('%+.4f * z^(-1) ', h(end))]);
 
    figure;
    stem(0:M-1, h);
    xlabel('n (Urutan Koefisien)');
    ylabel('Nilai Koefisien');
    title(['Struktur Filter dengan M = ' num2str(M)]);
    
    figure;
    freqz(h, 1, 1024, Fs);
    title(['Respon Frekuensi Filter dengan M = ' num2str(M)]);
    
    filtered_signal = filter(h, 1, xn);
    
    figure;
    subplot(2, 1, 1);
    stem(t, filtered_signal);
    xlabel('n (Waktu)');
    ylabel('Amplitudo');
    title(['Keluaran Filter dalam Domain Waktu untuk M = ' num2str(M)]);
    
    subplot(2, 1, 2);
    filtered_spectrum = fft(filtered_signal);
    stem(f, abs(filtered_spectrum));
    xlabel('Frekuensi (Hz)');
    ylabel('Amplitudo');
    title(['Spektrum Frekuensi Keluaran Filter untuk M = ' num2str(M)]);
end
