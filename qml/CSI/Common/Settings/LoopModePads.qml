import CSI 1.0

Module
{
	// input
	id: module
	property string loopSizePath: ""
	property string beatJumpPath: ""

	//------------------------------------------------------------------------------------------------------------------
  	// LOOPSIZE PADS
  	//------------------------------------------------------------------------------------------------------------------
	LoopSizes {
		name: "loop_sizes_1"
		path: module.loopSizePath + ".1"
		value: 2
	}

	LoopSizes {
		name: "loop_sizes_2"
		path: module.loopSizePath + ".2"
		value: 3
	}

	LoopSizes {
		name: "loop_sizes_3"
		path: module.loopSizePath + ".3"
		value: 4
	}

	LoopSizes {
		name: "loop_sizes_4"
		path: module.loopSizePath + ".4"
		value: 5
	}

	//------------------------------------------------------------------------------------------------------------------
  	// BEATJUMP PADS
  	//------------------------------------------------------------------------------------------------------------------
	JumpSizes {
		name: "jump_sizes_1"
		path: module.beatJumpPath + ".1"
		value: -13
	}

	JumpSizes {
		name: "jump_sizes_2"
		path: module.beatJumpPath + ".2"
		value: -7
	}

	JumpSizes {
		name: "jump_sizes_3"
		path: module.beatJumpPath + ".3"
		value: 7
	}

	JumpSizes {
		name: "jump_sizes_4"
		path: module.beatJumpPath + ".4"
		value: 13
	}
}