SRCPATH = 'tmp/libphonenumber/javascript/i18n/phonenumbers'
CLOSUREPATH = 'tmp/closure-library/closure/goog'

desc 'Import and build the latest version of libphonenumber'
task :import do
  unless File.exists?(SRCPATH)
    puts 'Downloading libphonenumber...'
    `svn export http://libphonenumber.googlecode.com/svn/trunk tmp/libphonenumber`
  end

  unless File.exists?(CLOSUREPATH)
    puts 'Downloading closure-library...'
    `svn export http://closure-library.googlecode.com/svn/trunk tmp/closure-library`
  end

  unless `which closure-compiler`.chomp.length > 0
    puts 'Please `brew install closure-compiler` and then run this again.'
    exit
  end

  puts 'Compiling...'
  system "closure-compiler --jscomp_warning=deprecated \
    --jscomp_warning=missingProperties \
    --js #{CLOSUREPATH}/base.js \
    --js #{CLOSUREPATH}/array/array.js \
    --js #{CLOSUREPATH}/asserts/asserts.js \
    --js #{CLOSUREPATH}/debug/error.js \
    --js #{CLOSUREPATH}/object/object.js \
    --js #{CLOSUREPATH}/proto2/descriptor.js \
    --js #{CLOSUREPATH}/proto2/fielddescriptor.js \
    --js #{CLOSUREPATH}/proto2/lazydeserializer.js \
    --js #{CLOSUREPATH}/proto2/message.js \
    --js #{CLOSUREPATH}/proto2/pbliteserializer.js \
    --js #{CLOSUREPATH}/proto2/objectserializer.js \
    --js #{CLOSUREPATH}/proto2/serializer.js \
    --js #{CLOSUREPATH}/proto2/util.js \
    --js #{CLOSUREPATH}/string/string.js \
    --js #{CLOSUREPATH}/string/stringbuffer.js \
    --js #{SRCPATH}/asyoutypeformatter.js \
    --js #{SRCPATH}/metadata.js \
    --js #{SRCPATH}/phonemetadata.pb.js \
    --js #{SRCPATH}/phonenumber.pb.js \
    --js #{SRCPATH}/phonenumberutil.js \
    --js_output_file=lib/fakie/js/libphonenumber.js"

  puts 'Done!'
end