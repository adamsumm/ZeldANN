 

my @size = qw/256/;
my @depth = qw/2/;
my @dropout = qw/0.8 0.9/;
my $maxEpoch = 100;
my @batchSize = qw/20 50/;
my @learningRate = qw/0.001 0.002/;
my @decay = qw/0.97/;
my @seq = qw/50 100 200 /;
#my $dat = "zelda";
my @dats = qw/zelda5 zelda10/;
foreach my $dat (@dats){
foreach my $s (@size) {
    foreach my $d (@depth){ 
	foreach my $dr (@dropout){
	    foreach my $b (@batchSize) {
		foreach my $lr (@learningRate){
		    foreach my $dc (@decay){
			foreach my $se (@seq){
system("th train.lua -rnn_size $s -num_layers $d -dropout $dr -seed 23 -learning_rate $lr -decay_rate $dc -seq_length $se -batch_size $b -max_epochs $maxEpoch -eval_val_every 500 -checkpoint_dir ${dat}_${s}_${d}_${dr}_${b}_${lr}_${dc}_${se} -data_dir data/$dat -init_from zelda10_256_2_0.8_50_0.002_0.97_100/lm_lstm_epoch50.00_0.0786.t7
\n");
			}
		    }
		}
	    }
	}
    }
}
}
