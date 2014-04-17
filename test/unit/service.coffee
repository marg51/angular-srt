describe 'uto.srt', ->
	Srt = Subtitles = mock = base = undefined


	beforeEach module('uto.srt')
	beforeEach module('uto.srt-mock')

	beforeEach inject (SrtService, srtMock, srtMockBase) ->
		Srt = SrtService
		mock = srtMock
		base = srtMockBase


	describe 'parse() -', ->
		it 'should parse our examples', ->
			for srt,srtKey in mock
				subtitles = Srt.parse(srt)

				for subtitle, key in subtitles
					expect(subtitle.start).toBe(base[srtKey][key].start)
					expect(subtitle.end).toBe(base[srtKey][key].end)
					expect(subtitle.text).toBe(base[srtKey][key].text)

		it 'should parse a simple example', ->
			expect( Srt.parse("1\n00:00:06,386 --> 00:00:07,711\nMon Text")[0] ).toEqual({id:0, start: 6.386, end: 7.711, text:'Mon Text'})
		it 'should parse a simple example with \\r\\n', ->
			expect( Srt.parse("1\r\n00:00:06,386 --> 00:00:07,711\r\nMon Text")[0] ).toEqual({id:0, start: 6.386, end: 7.711, text:'Mon Text'})

		it 'should trim', ->
			obj = Srt.parse("1\n00:00:06,386 --> 00:00:07,711\n  Mon Text  ")[0]
			expect( obj.text ).toBe('Mon Text')

		it 'should understand multi empty line', ->
			obj = Srt.parse("1\n00:00:06,386 --> 00:00:07,711\nMon Text\n\n\n\n\n\n2\n00:00:16,386 --> 00:00:17,711\nMon Text2")[1]
			expect( obj.text ).toBe('Mon Text2')

		it 'should understand multi text line', ->
			obj = Srt.parse("1\n00:00:06,386 --> 00:00:07,711\nMon Text\nest sur\nplusieurs lignes")[0]
			expect( obj.text ).toBe('Mon Text\nest sur\nplusieurs lignes')

		it 'should raise an error if it is malformed', ->
			fn = ->
				obj = Srt.parse("1\n00:00:06,386 --> 00:00:07,711")[0]
			expect( fn ).toThrow()
			
		it 'should raise an error if it is malformed #2', ->
			fn = ->
				obj = Srt.parse("1\n00:00:06,386 --> 00:00:07,711\nMon text\n\n2\neee\nMon text")[0]
			expect( fn ).toThrow()

	describe 'toSeconds() -', ->
		it 'test #1', ->
			expect( Srt.toSeconds('00:00:07.711') ).toBe 7.711
		it 'test #2', ->
			expect( Srt.toSeconds('00:02:07.711') ).toBe 127.711
		it 'test #3', ->
			expect( Srt.toSeconds('01:03:07.711') ).toBe 3787.711
		it 'test #4', ->
			expect( Srt.toSeconds('00:00:07') ).toBe 7
		it 'test #5', ->
			expect( Srt.toSeconds('00:00:00.001') ).toBe 0.001
		it 'test #6', ->
			expect( Srt.toSeconds('00:00:00.0001') ).toBe 0.0001

	describe 'toTimestamp() -', ->
		it 'test #1', ->
			expect( Srt.toTimestamp(7.711) ).toBe '00:00:07,711'
		it 'test #2', ->
			expect( Srt.toTimestamp(7) ).toBe '00:00:07'
		it 'test #3', ->
			expect( Srt.toTimestamp(127) ).toBe '00:02:07'
		it 'test #4', ->
			expect( Srt.toTimestamp(3127) ).toBe '00:52:07'
		it 'test #5', ->
			expect( Srt.toTimestamp(3727) ).toBe '01:02:07'
		it 'test #6', ->
			expect( Srt.toTimestamp(7307) ).toBe '02:01:47'
		it 'test #7', ->
			expect( Srt.toTimestamp(36107) ).toBe '10:01:47'
		it 'test #8', ->
			expect( Srt.toTimestamp(1.2) ).toBe '00:00:01,200'
		it 'test #9', ->
			expect( Srt.toTimestamp(1.21) ).toBe '00:00:01,210'
		it 'test #10', ->
			expect( Srt.toTimestamp(1.232) ).toBe '00:00:01,232'
		it 'test #11', ->
			expect( Srt.toTimestamp(0) ).toBe '00:00:00'
		it 'test #12', ->
			expect( Srt.toTimestamp(0.0001) ).toBe '00:00:00'

	describe 'stringify() -', ->
		it 'should stringify our examples', ->
			for subtitles, key in base
				srt = Srt.stringify(subtitles)

				expect(srt).toBe(mock[key])

		it 'should stringify this simple example', ->
			expect( Srt.stringify([{id:"it isnt taken", start:1, end:2, text:"Mon Text"}]) ).toBe "1\n00:00:01 --> 00:00:02\nMon Text\n\n"
