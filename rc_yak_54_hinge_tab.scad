// RC Yak Replacement Hinge Tab

overlap=0.01;
$fn=50;

hingeRodDia=4.3;

hingeBottomScrewHoleDia=2.5;

hingeAnchorHoleDia=2.2;
hingeAnchorHoleSpacing=3.3;

clipOpeningAngle=70;
clipOpeningInwardShift=1.3;

hingeTabLength=20.5;
hingeTabTipWidth=5.15;
hingeTabThickness=2.2;

hingeRodMarginWidth=2.2;

hingeEndOuterDia=hingeRodDia+hingeRodMarginWidth*2;

earBaseWidth=14;
earThickness=2;
earInnerWidth=hingeEndOuterDia;

tailGuardCurveDia=12;
curveCutInset=1.8;
// Note: when step down is == inset, hinge aligns with inner surface of tail-guard
bottomHingeStepDown=curveCutInset;  

// Calc
tabEndYPosition=hingeTabLength-hingeRodMarginWidth-hingeRodDia/2;

* translate([-15,0,0])
    forkedClipHinge();

* translate([0,0,0])
    forkedClipHinge();

translate([0,0,0])
    bottomHinge();

* translate([15,0,0])
    forkedClipHinge();

/*
 * Usually part of the tail-guard, but glue-in replacement
 * Note: Can't go inside/above tail-guard because that doesn't line
 * up right with the bottom end of the tail hinge.  Needs to be designed
 * to stair-step so it aligns with the surface of the tail-guard.
 */
module bottomHinge() {
    intersection() {
        difference() {
            anchoredHingeTab(tabThickness=hingeTabThickness+bottomHingeStepDown);
            translate([0,0,-overlap])
                cylinder(d=hingeBottomScrewHoleDia, h=hingeTabThickness+bottomHingeStepDown+overlap*2);
            translate([0,0,hingeTabThickness])
                cylinder(d=hingeEndOuterDia+overlap*2, h=bottomHingeStepDown+overlap);
            // under-curve
            translate([0,hingeEndOuterDia/2,curveCutInset])
                difference() {
                    translate([-tailGuardCurveDia/2,0,-curveCutInset-overlap])
                        cube([tailGuardCurveDia,hingeTabLength,tailGuardCurveDia/2+curveCutInset+overlap]);
                    translate([0,0,tailGuardCurveDia/2])
                        rotate([-90,0,0])
                            translate([0,0,-overlap])
                                cylinder(d=tailGuardCurveDia, h=hingeTabLength+overlap*2);
                }
        }

    }
}

module forkedClipHinge() {
    difference() {
        clipHinge();
        translate([-hingeAnchorHoleDia/2,tabEndYPosition-hingeAnchorHoleSpacing*3,-overlap])
            cube([hingeAnchorHoleDia,hingeAnchorHoleSpacing*3+overlap,hingeTabThickness+overlap*2]);
    }
}

module clipHinge() {     
    difference() {
        hingeWithEars();
        translate([0,clipOpeningInwardShift,0])
            rotate([0,0,-90-clipOpeningAngle/2])
                translate([0,0,-overlap])
                    rotate_extrude(angle=clipOpeningAngle) {
                        // note extra width (x-dimension) is to allow it to be shifted toward the center
                        square([hingeRodDia/2+hingeRodMarginWidth*2, hingeTabThickness+overlap*2]);
                    }
    }
}

module hingeWithEars() {
    union() {
        topHinge();
        // ears
        translate([0,hingeRodDia/2,0])
            hull() {
                // wide side
                translate([-earBaseWidth/2,earThickness-overlap,0])
                    cube([earBaseWidth,overlap,hingeTabThickness]);
                // narrow side
                translate([-earInnerWidth/2,0,0])
                    cube([earInnerWidth,overlap,hingeTabThickness]);
            }
    }
}

module topHinge() {
    difference() {
        anchoredHingeTab();
        translate([0,0,-overlap])
            cylinder(d=hingeRodDia, h=hingeTabThickness+overlap*2);
    }
}

module anchoredHingeTab(tabThickness=hingeTabThickness) {     
    difference() {
        hull() {
            cylinder(d=hingeEndOuterDia, h=tabThickness);
            translate([-hingeTabTipWidth/2,tabEndYPosition-overlap,0])
                cube([hingeTabTipWidth,overlap,tabThickness]);
        }
        // anchor holes    
        for (i=[1:3]) {
            translate([0,tabEndYPosition-hingeAnchorHoleSpacing*i,-overlap])
                cylinder(d=hingeAnchorHoleDia, h=tabThickness+overlap*2);    
        }
    }
}