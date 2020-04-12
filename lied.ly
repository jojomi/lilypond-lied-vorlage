\version "2.20.0"


\paper {
  set-paper-size = "a4"
  myStaffSize = #20
  % andere Fonts: Nunito oder Arial
  #(define fonts
   (make-pango-font-tree "Asul" 
                         "Asul"
                         "Tomorrow"
                          (/ myStaffSize 20)))
}

\include "deutsch.ly"
\language "deutsch"


% ===================
%   Noten und Text
% ===================

\header {
  title = ""
  subtitle = ""
  composer = \markup {\bold {"Melodie:"} ""}
  poet = \markup {\bold {"Text:"} ""}
  tagline = ""
}

stimmeGlobal = {
  %\autoBeamOff
  \clef treble
  \key f \major
  \time 4/4
  %\partial 4

  \tempo 4 = 120
}

StimmeEins = {
  \new Voice = "VoiceEins" {
    \stimmeGlobal

    \transpose f f {
      \relative c' {
        % Noten der Ersten Stimme
        \bar "|."
      }
    }
  }
}

StimmeZwei = {
  \new Voice = "VoiceZwei" {
    \stimmeGlobal

    \transpose f f {
      \relative c' {
        % Noten der Zweiten Stimme
        \bar "|."
      }
    }
  }
}


Akkorde = \chordmode {
  \germanChords
  \stimmeGlobal
  \set chordChanges = ##t
  
  \transpose f f {
    % Akkorde
  }
}

Text = {
  \lyricmode {
    \set stanza = " 1. "

    % Text der Singstimme
  }
}
TextWiederholung = {
  \lyricmode{
    % Text der Singstimme (für Wiederholungen)
  }
}


% ===================
% technischer Bereich
% ===================

stimmeBasics = {
  \clef violin
  \semiGermanChords
  \set chordChanges = ##t
}

% Da Capo al Fine
dcaf = { 
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \mark \markup\small\caps "D.C. al Fine" \bar "||"
}
fine = {
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \mark \markup\small\caps "Fine" \bar "|."
}
fineNoBar = {
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \mark \markup\small\caps "Fine"
}

% Dal Signo al Fine
dsaf = {
  \once \override Score.RehearsalMark #'self-alignment-X = #RIGHT
  \mark\markup{
    \small\caps "D.S. al Fine"
    \tiny \raise #1
    \musicglyph #"scripts.segno"
  }
}
segno = {
  \mark \markup { \musicglyph #"scripts.segno" }
}

refrainMark = {
  \once \override Score.RehearsalMark #'self-alignment-X = #LEFT
  \mark \markup{
    \small\bold "Refrain"
  }
}

\layout {
  indent = #0
  \context {
    \Lyrics
      \override LyricSpace #'minimum-distance = #1.6
  }
}


% ===================
% Ausgabedefinitionen
% ===================

\include "articulate.ly"

% PDF
\score{
  \new ChoirStaff <<
    \new ChordNames {
      \Akkorde
    }
    % http://lilypond.org/doc/v2.19/Documentation/notation/midi-instruments.en.html
    \new Staff <<
      \StimmeEins
      \new Lyrics = Strophe \lyricsto VoiceEins \Text
      \new Lyrics = Strophe \lyricsto VoiceEins \TextWiederholung
    >>
    \new Staff <<
      \new Voice = "S2" {
        \StimmeZwei
      }
    >>
    % Akkorde unter der Zweiten Stimme
    % \new ChordNames {
    %  \Akkorde
    %}
  >>
  \layout {
    \context {
      \Score
      %proportionalNotationDuration = #(ly:make-moment 1 20)
      \override SpacingSpanner
        #'base-shortest-duration = #(ly:make-moment 1 16)
    }
  }
}

% MIDI
\score{
  \new ChoirStaff <<
    \new Staff \with {
      midiInstrument = #"flute"
      midiMaximumVolume = #0.55
    } <<
      \unfoldRepeats
      \Akkorde
    >>
    % http://lilypond.org/doc/v2.19/Documentation/notation/midi-instruments.en.html
    \new Staff \with {
      midiInstrument = #"piano"
    } <<
      \unfoldRepeats \articulate
      \StimmeEins
    >>
    \new Staff \with {
      midiInstrument = #"piano"
    } <<
      \new Voice = "S2" {
        \unfoldRepeats \articulate
        \StimmeZwei
      }
    >>
  >>
  \midi{}
}