import CSI 1.0

Module {
	// input
	id: module
	property string path: ""
	property int value: 0

	MappingPropertyDescriptor
  	{
    	path: module.path
    	type: MappingPropertyDescriptor.Integer
    	value: module.value
    	values:
    	[
      		MappingPropertyValue { value: 0;  description: "1/32" },
      		MappingPropertyValue { value: 1;  description: "1/16" },
      		MappingPropertyValue { value: 2;  description: "1/8"  },
      		MappingPropertyValue { value: 3;  description: "1/4"  },
      		MappingPropertyValue { value: 4;  description: "1/2"  },
      		MappingPropertyValue { value: 5;  description: "1"    },
      		MappingPropertyValue { value: 6;  description: "2"    },
      		MappingPropertyValue { value: 7;  description: "4"    },
      		MappingPropertyValue { value: 8;  description: "8"    },
      		MappingPropertyValue { value: 9;  description: "16"   },
      		MappingPropertyValue { value: 10; description: "32"   }
    	]
  	}
}