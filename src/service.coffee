app = angular.module('uto.srt', [])

app.factory 'SrtService', ->
	$scope = {}

	$scope.parse = (text) ->
		subtitles = []
		text = text.replace /\r\n|\r|\n/g, "\n" # windows / mac / linux
		text = text.replace /\n{3,}/g, "\n\n" # max double empty line
		text = text.replace(/^\s+|\s+$/g,"") # trim()

		srt = text.split "\n\n"
		for el,key in srt
			obj = {}
			sub = el.split "\n"
			if sub.length > 3
				sub[2] = sub.slice(2).join "\n"
			if sub.length > 2 and sub[1].match(/\ --> /)
				obj.id = parseInt(sub[0])-1
				time = sub[1].split(" --> ")
				obj.start = $scope.toSeconds time[0]
				obj.end = $scope.toSeconds time[1]
				obj.text = sub[2].replace(/^\s+|\s+$/g,"") # trim()

				subtitles.push obj
			else 
				throw new Error("Malformed subtitle ##{key+1}")

		return subtitles


	$scope.toSeconds = (time) ->
		s = 0.0
		if time
			els = time.split ":"
			i = 0
			while i < els.length
				s = s*60+parseFloat(els[i].replace ",", ".")
				i++

		return s

	$scope.toTimestamp = (time) ->
		heures = Math.floor(time/3600)
		minutes = Math.floor( (time-(heures*3600) ) /60 )
		secondes = (time-(heures*3600)-(minutes*60))
		heures = '0'+heures if heures < 10
		minutes = '0'+minutes if minutes < 10
		scd = secondes.toFixed(3).replace('.',',').replace(',000','')
		scd = '0' + scd if secondes < 10
		
		return heures + ':' + minutes + ':' + scd

	$scope.stringify = (json) ->
		string = ""
		for el, key in json
			string+=key+1+'\n'
			string+=$scope.toTimestamp(el.start)+' --> '+$scope.toTimestamp(el.end)+'\n'
			string+=el.text+'\n'
			string+='\n'

		string


	return $scope
