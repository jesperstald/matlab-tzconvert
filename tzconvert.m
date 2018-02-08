classdef tzconvert
	properties
		online_url = 'http://unicode.org/repos/cldr/trunk/common/supplemental/windowsZones.xml'
		localcopy = fullfile(fileparts(mfilename('fullpath')), 'windowsZones.xml')
		xml
		maxage = inf % maximum local age in days
		wzlist
  end

	methods(Hidden)
		function tc = tzconvert
			% load xml file
			finfo = dir(tc.localcopy);
			if isempty(finfo) || finfo.datenum < now - tc.maxage
				tc.xml = xmlread(tc.online_url);
				xmlwrite(tc.localcopy, tc.xml)

			else
				tc.xml = xmlread(tc.localcopy);
			end
			tc.wzlist = tc.xml.getElementsByTagName('mapZone');
		end
	end

	methods(Static, Access = 'private')
		function tz_out = getMatch(tz_in_type, tz_in)
		% look up first match for either iana or windows time zone.
			tc = tzconvert;
			switch lower(tz_in_type)
				case 'iana'
					lookup_attr = 'type';
					return_attr = 'other';
				case 'windows'
					lookup_attr = 'other';
					return_attr = 'type';
			end
			for n = 0 : tc.wzlist.getLength - 1
				if strcmpi(tc.wzlist.item(n).getAttribute(lookup_attr), tz_in)
					tz_out = char(tc.wzlist.item(n).getAttribute(return_attr));
					return
				end
			end
			error('Invalid %s timezone: ''%s''', tz_in_type, tz_in);
		end
	end

	methods(Static, Access = 'public')
		function tz = IANA2Windows(tz_iana)
			tz = tzconvert.getMatch('iana', tz_iana);
		end

		function tz = Windows2IANA(tz_windows)
			tz = tzconvert.getMatch('windows', tz_windows);
		end
	end
end
