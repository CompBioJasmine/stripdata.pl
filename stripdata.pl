#!/usr/bin/perl -w

my( @lines );
my( @tabs );
my( @new );
my( @nums );
my( %HOH );
my( $tab, $line, $gene, $number, $blank, $genekey );

open( DATA, "<MS_MasterFile_txt.txt" ) or die ( "No such file!\n" );
@lines = <DATA>;
close( DATA );

#remove first line
shift( @lines );

#get gene keys in second line
$line = shift( @lines );
chomp( $line );
$line =~ s/"//g;
@genekeys = split( /\t/, $line );

#split lines into tabs
foreach $line ( @lines ) {
  chomp( $line );
  @tabs = split( /\t/, $line );

  #get gene name/value and put in hash indexed by genekey
  for ($i = 0; $i < @tabs; $i++) {
    $tab = $tabs[$i];
    if ( GetGeneName( $tab ) ) {
      $gene = GetGeneName( $tab );
    }
    elsif ( GetNumber( $tab ) ) {
      $genekey = $genekeys[$i];
      $number = GetNumber( $tab );
      $HOH{$genekey}{$gene} = $number;
    }
    elsif ( GetBlank( $tab ) ) {
      $blank = GetBlank( $tab );
    }
    else {
      $gene = $tab;
    }
  }
}

# loop over keys and do something
for $genekey ( keys %HOH ) {
    print "$genekey:\n";
    for $gene ( keys %{ $HOH{$genekey} } ) {
         print "\t$gene = $HOH{$genekey}{$gene}\n";
    }
    print "\n";
}

exit;

sub GetGeneName{
  my ( $tab ) = @_;
  my ( $genename );
  if( $tab =~ m/ GN=([^\s]+)\s/ ) {
    $genename = $1;
  }
  elsif( $tab =~ m/Gene_Symbol=([^\s]+)\s/ ) {
    $genename = $1;
  }
  else {
    $genename="";
  }
  return $genename;
}

sub GetNumber{
  my( $tab ) = @_;
  my( $number );
  if( $tab =~ m/(\d\.\d\d[^\s]+)\s*$/ ) {
    $number = $1;
  }
  else {
    $number="";
  }
  return $number;
}

sub GetBlank{
  my( $tab ) = @_;
  if( $tab =~ m/^\s*$/) {
    return 1;
  }
  return "";
}
