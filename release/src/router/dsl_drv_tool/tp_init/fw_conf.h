
#define MAX_PVC 8


enum {
    EnumAdslModeT1,
    EnumAdslModeGlite,
    EnumAdslModeGdmt,
    EnumAdslModeAdsl2,
    EnumAdslModeAdsl2plus,
    EnumAdslModeMultimode,
};


// Annex B has different HW and FW from Annex AIJKM
enum {
    EnumAdslTypeA = 0,
    EnumAdslTypeI,    
    EnumAdslTypeA_L,    
    EnumAdslTypeM,
    EnumAdslTypeA_I_J_L_M,
    EnumAdslTypeB,
    EnumAdslTypeB_J_M
};

enum {
	EnumSNRMOffset,
};

enum {
	EnumSRA,
};

enum {
	EnumBitswap,
};
