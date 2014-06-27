Pod::Spec.new do |s|
    s.name              = 'LolayStrands'
    s.version           = '1'
    s.summary           = 'Library for handling threading and queues within iOS. Both with blocks and without (i.e. iOS 3.1)'
    s.homepage          = 'https://github.com/lolay/strands'
    s.license           = {
        :type => 'Apache',
        :file => 'LICENSE'
    }
    s.author            = {
        'Lolay' => 'support@lolay.com'
    }
    s.source            = {
        :git => 'https://github.com/lolay/strands.git',
        :tag => "1"
    }
    s.source_files      = 'Lolay*.{h,m}'
    s.requires_arc      = true
	s.ios.deployment_target = '7.0'
end
