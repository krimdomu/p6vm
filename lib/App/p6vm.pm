#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package App::p6vm;

use LWP::Simple;
use LWP::UserAgent;

my $logfile;

sub new {
   my $that = shift;
   my $proto = ref($that) || $that;
   my $self = { @_ };

   bless($self, $proto);

   $self->{url}    ||= "http://rakudo.org/downloads/star/";
   $self->{prefix} ||= $ENV{HOME} . "/perl6/p6vm"; 

   return $self;
}

sub prefix {
   my ($self, $prefix) = @_;

   if($prefix) { $self->{prefix} = $prefix; };

   $self->{prefix};
}

sub dir {
   my ($self, $dir) = @_;
   return $self->prefix . "/$dir";
}

sub list {

   my ($self) = @_;
   my $directory_listing = get($self->{url});

   my @links = ($directory_listing =~ m/(rakudo-star-\d+.\d+)\.tar\.gz/g);

   return @links;

}

sub list_local {
   
   my ($self) = @_;
   my @ret;

   opendir(my $dh, $self->dir("perls")) or die($!);
   while(my $entry = readdir($dh)) {
      next if($entry =~ m/^\./);
      next if($entry eq "active");
      push(@ret, $entry);
   }
   closedir($dh);

   return @ret;
}

sub install {

   my ($self, $option, $version) = @_;

   $logfile = $self->dir("tmp") . "/build.log";

   notify("Installing $version (logfile: $logfile)");

   notify_and_wait("   Downloading $version");

   my $ua = LWP::UserAgent->new();
   open(my $fh, ">", $self->dir("tmp") . "/$version.tar.gz") or do { notify_failed(); return; };
   binmode $fh;
   my $resp = $ua->get($self->{url} . "/$version.tar.gz", ":content_cb" => sub {
      my ($data, $response, $protocol) = @_;
      print $fh $data;
   });
   close($fh);

   notify_ok();


   chdir($self->dir("tmp"));
   eval {
      notify_cmd("tar xzf $version.tar.gz", "   Extracting $version");
   } or do {
      notify("Extract of " . $self->dir("tmp") ."/$version.tar.gz failed. Please see $logfile fore more information.");
      notify($@);
      exit 1;
   };

   chdir($version);

   my $prefix = $self->dir("perls/$version");

   eval {
      notify_cmd("perl Configure.pl --prefix=$prefix --gen-parrot --gen-moar --gen-nqp --backends=parrot,jvm,moar", "   Configuring $version");
   } or do {
      notify("Configure.pl failed. Please see $logfile for more information.");
      exit 1;
   };

   eval {
      notify_cmd("make", "   Making $version");
   } or do {
      notify("make failed. Please see $logfile for more information.");
      exit 1;
   };

   eval {
      notify_cmd("make install", "   Installing $version");
   } or do {
      notify("make install failed. Please see /tmp/build.log for more information.");
      exit 1;
   };

   notify("Installation of $version done.");
}



################################################################################
# static functions
################################################################################

sub notify_cmd {
   my ($cmd, $msg) = @_;

   notify_and_wait($msg);

   $logfile ||= "/tmp/p6vm.log";

   system("$cmd >$logfile 2>&1");
   if($? == 0) {
      notify_ok();
      return 1;
   }
   else {
      notify_failed();
      die($?);
   }

}

sub notify {
   my ($msg, $type) = @_;
   $type ||= "+";

   print "[$type] $msg\n";
}

my $last_message;
sub notify_and_wait {
   $last_message = shift;
   print "[-] " . $last_message;
}

sub notify_ok {
   if($last_message) {
      print "\r";
      my $len = length($last_message) + 2;
      print " "x$len;
      print "\r"; notify($last_message);
      $last_message = undef;
   }
}

sub notify_failed {
   if($last_message) {
      print "\r";
      my $len = length($last_message) + 2;
      print " "x$len;
      print "\r"; notify($last_message, "!");
      $last_message = undef;
   }
}
1;
