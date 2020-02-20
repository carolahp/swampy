# swampy

Example of usage:

aContext := [ 1 + 2 even ] asContext.

SWDebugger basicNew 
	debugSession: (SWDebugSession onContext: (failing := SWContextFailingStep on: aContext));
	initialize;
	openWithSpec .

ToDo:
- Baseline (load package DebuggableASTDebugger from DebuggableASTInterpreter project)
