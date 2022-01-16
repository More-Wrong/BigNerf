include <ScrewsMetric/ScrewsMetric.scad>;
include <ScrewsMetric/Optional-Frames.scad>;
include <ScrewsMetric/Optional-Steppers.scad>;
include <ScrewsMetric/Optional-Bearings.scad>;
//include <Getriebe.scad>;
beltT = 2;
beltW = 75;
bulletD = 13;

casingBoltSize = M2;

casingT = 1;
casingCutOff = 0.5;
casingEndT = 1;
casingBottomExtraT = 4;
casingHoldArmT = 3;
casingHoldArmL = 5;
casingHoldArmOffsetFromEnd = 10;
casingHoldArmOffset = 15;
casingGripT = 0.3;
casingGripL = 1;


casingBoltOffset = 15;
casingBoltExtraInset = 0.5;
casingBoltErr = 0.3;

casingNutInset = 2.5;

casingPairH = 5;
casingPairHoleW = 8;
casingPairHoleTiltW = 12;
casingPairHoleL = 70;
casingPairHoleTiltL = 50;



casingW = 15;



beltDriveWheelSides = 12;
beltDriveWheelBoltExcessL = 2;
beltDriveWheelBoltExcessD = 5;

boltNutSlack = 0.15;

casingGearSlack = 0.5;
casingGearBoltSize = M3;
casingGearBoltCount = 3;
casingGearHolderT = 8;
casingGearHolderH = 8;
casingGearRodD = 8;


GHOST=true;

bulletHoleMin = 4;
casingAngleShort = 30;
casingAngleLong = 40;
casingSpikeLength = 15;
casingHolderT = 1.5;

casingRearL = 0;
casingRearGap = 1;
casingSpikeMovement = 1.5;
casingSpikeAng = 6.5;
casingSpikeToothL = 1;


module shellCasingTop(ghost = true){
   intersection(){
      difference(){
         union(){
            translate([-casingRearL, -bulletD/2, 0])cube([beltW+casingRearL, bulletD, casingBottomExtraT+bulletD/2+bulletHoleMin/2]);
         }
         translate([-casingRearL-0.011, 0, casingBottomExtraT+bulletD/2])rotate([0, 90, 0])difference(){
            union(){
               translate([0, 0, casingRearL+casingHolderT])cylinder(h = beltW+0.002, d = bulletD);
               translate([0, 0, casingRearL-casingRearGap])cylinder(h = casingRearGap, d = bulletD);
               rotate([0, casingSpikeAng, 0])cylinder(h = casingRearL, d = bulletHoleMin+casingSpikeMovement*2);
            }
            rotate([0, casingSpikeAng, 0]){
               
               difference(){
                  cylinder(h = casingRearL+casingSpikeLength, d = bulletHoleMin);
                  translate([-bulletHoleMin*5/4, -bulletHoleMin/2, 0])cube([bulletHoleMin, bulletHoleMin, casingRearL]);
               }
               translate([0, 0, casingRearL+casingSpikeLength])sphere(d = bulletHoleMin);
               translate([0, 0, casingRearL+casingSpikeLength])rotate([0, 90, 0])cylinder(h = bulletHoleMin/2+casingSpikeToothL, d = bulletHoleMin);
            }
         }
         translate([casingBoltOffset, 0, casingBottomExtraT-M(casingBoltSize, allenBoltHeadH)-casingBoltExtraInset]){
            AllenBoltHole(casingBoltSize, casingBottomExtraT+0.001, bulletD/2-bulletHoleMin/2, ERR = casingBoltErr);
            translate([beltW-casingBoltOffset*2, 0, 0])AllenBoltHole(casingBoltSize, casingBottomExtraT+0.001, bulletD/2-bulletHoleMin/2, ERR = casingBoltErr);
         }
      }
      translate([-casingRearL, 0, casingBottomExtraT+bulletD/2+bulletHoleMin/2])rotate([-90-casingAngleShort, 0, 0])translate([0, -bulletHoleMin, 0])cube([beltW+casingRearL, casingBottomExtraT+bulletD+bulletHoleMin, casingBottomExtraT+bulletD/2+bulletHoleMin/2]);
      union(){
         difference(){
            translate([-casingRearL, 0, casingBottomExtraT+bulletD/2+bulletHoleMin/2])rotate([-180+casingAngleLong, 0, 0])cube([beltW+casingRearL, casingBottomExtraT+bulletD+bulletHoleMin, casingBottomExtraT+bulletD+bulletHoleMin]);
            translate([-casingRearL, 0.001, casingBottomExtraT+bulletD/2+bulletHoleMin/2])rotate([-180+casingAngleLong, 0, 0])cube([beltW+casingRearL, bulletHoleMin/2, bulletHoleMin/2]);
         }
         translate([-casingRearL, 0, casingBottomExtraT+bulletD/2])rotate([0, casingSpikeAng, 0])rotate([0, 90, 0])cylinder(h = beltW+casingRearL+0.002, d = bulletHoleMin);
      }
   }
   %if(ghost)translate([casingHolderT, 0, casingBottomExtraT+bulletD/2])rotate([0, 90, 0])difference(){
      cylinder(d = bulletD, h = beltW-casingHolderT);
      translate([0, 0, -0.001])cylinder(d = bulletHoleMin, h = casingSpikeLength/2+beltW/2-casingHolderT);
   }
}
//!rotate([90+casingAngleShort, 0, 0])shellCasingTop();
module shellCasingBottomKey(err = 0){
    translate([beltW/2, 0, -0.001])hull(){
        translate([-casingPairHoleL/2-err, -casingPairHoleW/2-err, 0])cube([casingPairHoleL+err*2, casingPairHoleW+err*2, 0.001]);
        translate([-casingPairHoleTiltL/2-err, -casingPairHoleTiltW/2-err, casingPairH])cube([casingPairHoleTiltL+err*2, casingPairHoleTiltW+err*2, 0.002]);
    }
}
module shellCasingBottom(){
    difference(){
        shellCasingBottomKey();
        translate([casingBoltOffset, 0, -0.002]){
            translate([0, 0, casingNutInset])mirror([0, 0, 1])FullNut(casingBoltSize, ERR = casingBoltErr/2, VertERR=casingNutInset);
            Rod(casingBoltSize, casingPairH+0.004, ERR = casingBoltErr);
        }
        translate([beltW-casingBoltOffset, 0, -0.002]){
            translate([0, 0, casingNutInset])mirror([0, 0, 1])FullNut(casingBoltSize, ERR = casingBoltErr/2, VertERR=casingNutInset);
            Rod(casingBoltSize, casingPairH+0.004, ERR = casingBoltErr);
        }
    }
}
module casingBottomGear(ghosts = true){
    flatDist = casingW/2/tan(180/beltDriveWheelSides);
    difference(){
        union(){
            for(i = [0:beltDriveWheelSides-1])rotate([0, i*360/beltDriveWheelSides, 0]){
                hull(){
                   translate([-casingW/2, casingPairHoleL/2-casingPairHoleTiltL/2, 0])cube([casingW, casingPairHoleTiltL, flatDist]);
                   translate([-casingW*(flatDist-casingPairH)/flatDist/2, 0, 0])cube([casingW*(flatDist-casingPairH)/flatDist, casingPairHoleL, flatDist-casingPairH]);
                }
                if(GHOST && ghosts){
                    %translate([0, casingPairHoleL/2-beltW/2, beltT+flatDist])rotate([0, 0, 90])shellCasingTop();
                }
            }
            //rotate([-90, 0, 0])cylinder(d = casingGearRodD+casingGearHolderT*2, h = casingGearHolderH+beltW);
            //rotate([-90, 0, 0])cylinder(d = casingW/tan(180/beltDriveWheelSides), h = beltW/2-casingPairHoleL/2);
            //rotate([-90, 0, 0])translate([0, 0, casingPairHoleL/2+beltW/2])cylinder(d = casingW/tan(180/beltDriveWheelSides), h = beltW/2-casingPairHoleL/2);
        }
        for(i = [0:beltDriveWheelSides-1])rotate([0, i*360/beltDriveWheelSides, 0]){
            translate([0, casingPairHoleL/2-beltW/2, (casingW/2)/tan(180/beltDriveWheelSides)-casingPairH])rotate([0, 0, 90]){
                translate([casingBoltOffset, 0, -beltDriveWheelBoltExcessL])cylinder(d = beltDriveWheelBoltExcessD, h = beltDriveWheelBoltExcessL);
                translate([beltW-casingBoltOffset, 0, -beltDriveWheelBoltExcessL])cylinder(d = beltDriveWheelBoltExcessD, h = beltDriveWheelBoltExcessL);
                shellCasingBottomKey(err = casingGearSlack);
            }
            
        }
        translate([0, -0.001, 0])rotate([-90, 0, 0])cylinder(d = casingGearRodD+casingGearSlack, h = casingGearHolderH+beltW+0.002);
        
        
        translate([0, casingPairHoleL-casingGearHolderH/2, 0])for(i = [0: casingGearBoltCount-1])rotate([0, i*360/casingGearBoltCount, 0]){
            translate([0, 0, casingGearHolderT/2+casingGearRodD/2-M(casingGearBoltSize, fullNutH)/2])rotate([0, 0, -90 ])FullNutHole(casingGearBoltSize, casingGearHolderH/2+0.001, ERR=boltNutSlack, VertERR = boltNutSlack*2);
            Rod(casingGearBoltSize, flatDist, ERR=boltNutSlack);
        }
        translate([0, casingGearHolderH/2, 0])for(i = [0: casingGearBoltCount-1])rotate([0, i*360/casingGearBoltCount, 0]){
            translate([0, 0, casingGearHolderT/2+casingGearRodD/2-M(casingGearBoltSize, fullNutH)/2])rotate([0, 0, 90 ])FullNutHole(casingGearBoltSize, casingGearHolderH/2+0.001, ERR=boltNutSlack, VertERR = boltNutSlack*2);
            Rod(casingGearBoltSize, flatDist, ERR=boltNutSlack);
        }
    }
}

topGearAngle = 15;
//topGearTopR = casingW/2/tan(180/beltDriveWheelSides)/cos(180/beltDriveWheelSides); without compensating for angle
topGearOuterH = (casingPairHoleL-casingPairHoleTiltL)/2*cos(topGearAngle);
topGearShaftGap = 2;
topGearSurfaceExtraT = 5;

topGearTopR = (casingW/2/tan(180/beltDriveWheelSides)/cos(180/beltDriveWheelSides)+(topGearOuterH-casingPairH*sin(topGearAngle)/2+topGearSurfaceExtraT/2)*sin(topGearAngle))/cos(topGearAngle)-(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle);

topGearBigBearing = 6705_bearing;
topGearBigBearingRimSlopeT = 5;
topGearBigBearingRimW = 2;
topGearBigBearingErr = 0.2;
topGearBearingFreedom = 2;
topGearBearingBoltCount = 6;
topGearBearingBoltOffset = 4;
topGearBearingBoltSize = M3;
topGearBearingNutInset = 4;

topGearBearingHolderBoltType = allenButtonBolt;
topGearBearingHolderH = 3;
topGearBearingHolderT = 3;
topGearBearingHolderMinW = 6;

module casingTopGear(){
   outerR = topGearTopR+(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle);
   outerH = (casingPairHoleL-casingPairHoleTiltL)/2*cos(topGearAngle);
   innerR = topGearTopR-casingPairH*cos(topGearAngle);
   innerH = outerH-casingPairH*sin(topGearAngle);
   difference(){
      union(){
         cylinder(r1 = outerR, r2 = topGearTopR, h = outerH);
         translate([0, 0, outerH])cylinder(r1 = topGearTopR, r2 = topGearTopR-(outerR-topGearTopR)*topGearSurfaceExtraT/outerH, h = topGearSurfaceExtraT);
      }
      translate([0, 0, -0.001])cylinder(r1 = outerR, r2 = innerR, h = innerH);
      
      translate([0, 0, -0.001])cylinder(d = max((casingGearRodD+topGearShaftGap*2)+(topGearSurfaceExtraT+outerH+innerH)/2*sin(topGearAngle), BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingOuterDiam)/2+topGearBearingFreedom/2), h = topGearSurfaceExtraT+outerH+0.002+BearingDimention(topGearBigBearing, bearingThickness));
      echo(str("bearing minimum size = ", (casingGearRodD+topGearShaftGap*2)+(topGearSurfaceExtraT+outerH+innerH)/2*sin(topGearAngle)));
      translate([0, 0, outerH+topGearSurfaceExtraT-BearingDimention(topGearBigBearing, bearingThickness)*3/4+0.001])BearingType(topGearBigBearing, ERR = topGearBigBearingErr);
      for(i = [0:topGearBearingBoltCount-1])rotate([0, 0, i*360/topGearBearingBoltCount])translate([topGearBearingBoltOffset+BearingDimention(topGearBigBearing, bearingOuterDiam)/2, 0, innerH-0.001]){
         Rod(topGearBearingBoltSize, outerH+topGearSurfaceExtraT-innerH+0.002, ERR = 0.2);
         translate([0, 0, topGearBearingNutInset])mirror([0, 0, 1])FullNutVertHole(topGearBearingBoltSize, topGearBearingNutInset+0.001, ERR = 0.2);
      }
   }
}
module casingTopGearBearingHolder(useBigCylinder = true){
   outerH = (casingPairHoleL-casingPairHoleTiltL)/2*cos(topGearAngle);
   innerH = outerH-casingPairH*sin(topGearAngle);
   difference(){
      union(){
         if(useBigCylinder){
            cylinder(r = topGearBearingBoltOffset+BearingDimention(topGearBigBearing, bearingOuterDiam)/2+getHeadDiameter(topGearBearingHolderBoltType, topGearBearingBoltSize)/2+topGearBearingHolderT/2, h = topGearBearingHolderH);
         }else {
            for(i = [0:topGearBearingBoltCount-1])rotate([0, 0, i*360/topGearBearingBoltCount]){
               minimalBridge(topGearBearingHolderMinW, sep = topGearBearingBoltOffset+BearingDimention(topGearBigBearing, bearingOuterDiam)/2, d1 = BearingDimention(topGearBigBearing, bearingOuterDiam)+topGearBearingHolderT, d2 = getHeadDiameter(topGearBearingHolderBoltType, topGearBearingBoltSize)+topGearBearingHolderT, h = topGearBearingHolderH);
            }
         }
      }
      translate([0, 0, -0.001])cylinder(d = max((casingGearRodD+topGearShaftGap*2)+(topGearSurfaceExtraT+outerH+innerH)/2*sin(topGearAngle), BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingOuterDiam)/2+topGearBearingFreedom/2), h = topGearBearingHolderH+0.002);
      for(i = [0:topGearBearingBoltCount-1])rotate([0, 0, i*360/topGearBearingBoltCount])translate([topGearBearingBoltOffset+BearingDimention(topGearBigBearing, bearingOuterDiam)/2, 0, topGearBearingHolderH]){
         BoltNormalWithSurface(topGearBearingHolderBoltType, topGearBearingBoltSize, topGearBearingHolderH+0.002);
      }
   }
}
topGearHolderRodSlack = 1.5;
topGearHolderBigBearingGripBoltSize = M2;
topGearHolderBigBearingGripBoltType = allenBolt;
topGearHolderBigBearingGripBoltCount = 3;
topGearHolderBigBearingGripBoltRot = -30;
topGearHolderBigBearingGripBoltExtraL = 5;
topGearHolderBigBearingPlaneT = 8;
topGearHolderBigBearingHolderT = 3;

topGearHolderBearingOffset = 8;
driveRodBearingType = 608_bearing;
driveRodBearingCrush = 1;
driveRodBearingHoldingT = 5;
driveRodBearingHoldBoltCount = 3;
driveRodBearingHoldBoltSize = M3;
driveRodBearingHoldBoltType = allenButtonBolt;
driveRodBearingHoldBoltOffset = 4;
driveRodBearingTAroundHoldBolt = 3;
driveRodBearingExtraGap = 1.5;

module topGearHolder(){
   bearingRimD = BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingOuterDiam)/2-topGearBearingFreedom/2;
   difference(){
      union(){
         cylinder(d = BearingDimention(topGearBigBearing, bearingBore)-0.4, h = BearingDimention(topGearBigBearing, bearingThickness)*3/4);
         translate([0, 0 ,BearingDimention(topGearBigBearing, bearingThickness)*3/4])cylinder(d = bearingRimD, h = topGearHolderBigBearingPlaneT);
         intersection(){
            translate([0, 0 ,BearingDimention(topGearBigBearing, bearingThickness)*3/4+topGearHolderBigBearingPlaneT])cylinder(d = 100, h = 100);
            hull(){
               translate([0, 0 ,BearingDimention(topGearBigBearing, bearingThickness)*3/4+topGearHolderBigBearingPlaneT])cylinder(d = bearingRimD, h = 0.001);
               translate([0, 0, BearingDimention(topGearBigBearing, bearingThickness)/2-topGearSurfaceExtraT-topGearOuterH+((topGearSurfaceExtraT+topGearOuterH+topGearOuterH-casingPairH*sin(topGearAngle))/2)])rotate([topGearAngle, 0, 0])translate([0, 0, (BearingDimention(topGearBigBearing, bearingThickness)+topGearHolderBigBearingPlaneT)*cos(topGearAngle)]){
                  translate([0, 0, topGearHolderBearingOffset-driveRodBearingHoldingT])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
                  for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount])translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, topGearHolderBearingOffset-driveRodBearingHoldingT])cylinder(d = driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
               }
            }
         }
      }
      
      translate([0, 0, BearingDimention(topGearBigBearing, bearingThickness)/2-topGearSurfaceExtraT-topGearOuterH+((topGearSurfaceExtraT+topGearOuterH+topGearOuterH-casingPairH*sin(topGearAngle))/2)])rotate([topGearAngle, 0, 0]){
         translate([0, 0, -BearingDimention(topGearBigBearing, bearingBore)/2])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingThickness)*10+topGearHolderBigBearingPlaneT*10);
         translate([0, 0, (BearingDimention(topGearBigBearing, bearingThickness)+topGearHolderBigBearingPlaneT)*cos(topGearAngle)]){
            translate([0, 0, topGearHolderBearingOffset])BearingType(driveRodBearingType, ERR = 0.2);
            translate([0, 0, topGearHolderBearingOffset-driveRodBearingExtraGap])cylinder(d = casingGearRodD+topGearHolderRodSlack*2+driveRodBearingExtraGap*2, h = BearingDimention(driveRodBearingType, bearingThickness)+driveRodBearingExtraGap);
            translate([0, 0, topGearHolderBearingOffset-driveRodBearingHoldingT])for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
               translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])Rod(driveRodBearingHoldBoltSize, BearingDimention(driveRodBearingType, bearingThickness)+driveRodBearingHoldingT, ERR = 0.2);
               translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, BearingDimention(driveRodBearingType, bearingThickness)/2-driveRodBearingCrush/2-M(driveRodBearingHoldBoltSize, fullNutH)/2-0.25+driveRodBearingHoldingT/2])rotate([0, 0, -90])FullNutHole(driveRodBearingHoldBoltSize, driveRodBearingTAroundHoldBolt+M(driveRodBearingHoldBoltSize, boltD), ERR = 0.2, VertERR = 0.5);
            }
         }
      }
      
      for(i = [0: topGearHolderBigBearingGripBoltCount-1])rotate([0, 0, i*360/topGearHolderBigBearingGripBoltCount+topGearHolderBigBearingGripBoltRot]){
         translate([casingGearRodD/4+topGearHolderRodSlack/2+BearingDimention(topGearBigBearing, bearingBore)/4, 0, -BearingDimention(topGearBigBearing, bearingThickness)/4])Rod(topGearHolderBigBearingGripBoltSize, BearingDimention(topGearBigBearing, bearingThickness)+topGearHolderBigBearingPlaneT+topGearHolderBigBearingGripBoltExtraL, ERR = 0.2);
      }
      for(i = [0: topGearHolderBigBearingGripBoltCount-1])rotate([0, 0, i*360/topGearHolderBigBearingGripBoltCount+topGearHolderBigBearingGripBoltRot]){
         translate([casingGearRodD/4+topGearHolderRodSlack/2+BearingDimention(topGearBigBearing, bearingBore)/4, 0, BearingDimention(topGearBigBearing, bearingThickness)*3/4+topGearHolderBigBearingPlaneT/2-M(topGearHolderBigBearingGripBoltSize, fullNutH)/2-0.25])rotate([0, 0, 180])FullNutHole(topGearHolderBigBearingGripBoltSize, bearingRimD/2, ERR = 0.2, VertERR = 0.5);
      }
   }
}
module topGearHolderBigBearingHolder(){
   bearingRimD = BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingOuterDiam)/2-topGearBearingFreedom/2;
   difference(){
      union(){
         translate([0, 0 ,-BearingDimention(topGearBigBearing, bearingThickness)/4-topGearHolderBigBearingHolderT])cylinder(d = bearingRimD, h = topGearHolderBigBearingHolderT);
      }
      
      translate([0, 0, BearingDimention(topGearBigBearing, bearingThickness)/2-topGearSurfaceExtraT-topGearOuterH+((topGearSurfaceExtraT+topGearOuterH+topGearOuterH-casingPairH*sin(topGearAngle))/2)])rotate([topGearAngle, 0, 0])translate([0, 0, -BearingDimention(topGearBigBearing, bearingBore)/2-topGearHolderBigBearingHolderT])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingThickness)*10+topGearHolderBigBearingPlaneT*10);
      
      
      for(i = [0: topGearHolderBigBearingGripBoltCount-1])rotate([0, 0, i*360/topGearHolderBigBearingGripBoltCount+topGearHolderBigBearingGripBoltRot]){
         translate([casingGearRodD/4+topGearHolderRodSlack/2+BearingDimention(topGearBigBearing, bearingBore)/4, 0, -BearingDimention(topGearBigBearing, bearingThickness)/4-topGearHolderBigBearingHolderT])mirror([0, 0, 1])BoltNormalWithSurface(topGearHolderBigBearingGripBoltType, topGearHolderBigBearingGripBoltSize, BearingDimention(topGearBigBearing, bearingThickness)/4+topGearHolderBigBearingHolderT, ERR = 0.2);
      }
   }
}
module topGearHolderBearingHolder(){
   difference(){
      hull(){
         translate([0, 0, 0])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = driveRodBearingHoldingT);
         for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount])translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])cylinder(d = driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), h = driveRodBearingHoldingT);
      }
      translate([0, 0, -0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2+driveRodBearingExtraGap*2, h = driveRodBearingExtraGap);
      
      translate([0, 0, -0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = driveRodBearingHoldingT+0.002);
      
      for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
         translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, driveRodBearingHoldingT])BoltNormalWithSurface(driveRodBearingHoldBoltType, driveRodBearingHoldBoltSize, driveRodBearingHoldingT, ERR = 0.2);
      }
   }
}
motorBoltSize = M3;
motorBoltSep = 33;
motorCloseBoltSep = 16;
motorFarBoltSep = 19;
motorTotalD = 28;
motorCenterHoleD = 8;
motorTotalL = 40;
motorFiringSectionOffset = 10;
motorFiringSectionL = 10;
motorBodyL = 28;
motorWheelD = 45;
motorWheelBoltSize = M3;
motorWheelBoltHolderT = 5;

motorBackHoleLength = 5;
motorBackHoleD = 10;

roofHeight = 50;
topGearSurroundingHoleD = 70;
topGearSurroundingRingH = 32.3;
topGearSurroundingRingT = 3;
guideIdlerDistBelow = 50;
guideIdlerDistOut = 60;
guideIdlerRodD = 8;
guideIdlerTAroundRod = 3;
motorHeight = 55;
motorPlateT = 7;
motorSep = 10; 
motorBackwardForward = 2;
motorSlack = 2;
motorShieldT = 0.8;
motorWireHoleD = 10;

bulletFiringHoleStartD = 35;
bulletFiringHoleEndD = 17.5;

bulletFiringVertFudge = -3;
topGearSurroundingRingVertFudge = -5;

topGearConeStartSize = 55;
topGearConeEndInset = 2;
topGearConeStartH = 20;

barrelBoltSize = M3;
barrelBoltSep = 42;
barrelTopBoltIn = 5;
barrelTopBoltL = 8;
barrelTopBoltNutIn = 3;

module frontFrame(){
   bulletFiringDist = (topGearTopR+(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle))*cos(topGearAngle)+beltT+casingBottomExtraT+bulletD/2+bulletFiringVertFudge;
   totalW = max(motorSep+motorTotalD*2+motorSlack*2+motorShieldT*2, topGearSurroundingHoleD+topGearSurroundingRingT*2);
   module motorBoltHoles(l, h){
      rotate([0, 0, 45]){
         translate([motorCloseBoltSep/2, 0, l])AllenButtonBolt(motorBoltSize, l, ERR = 0.2);
         translate([-motorCloseBoltSep/2, 0, l])AllenButtonBolt(motorBoltSize, l, ERR = 0.2);
         translate([0, motorFarBoltSep/2, l])AllenButtonBolt(motorBoltSize, l, ERR = 0.2);
         translate([0, -motorFarBoltSep/2, l])AllenButtonBolt(motorBoltSize, l, ERR = 0.2);
      }
   }
   bearingRimD = BearingDimention(topGearBigBearing, bearingBore)/2+BearingDimention(topGearBigBearing, bearingOuterDiam)/2-topGearBearingFreedom/2;
   difference(){
      union(){
         translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT])cylinder(d = totalW, h = topGearSurroundingRingH);
         translate([-totalW/2, topGearSurroundingRingVertFudge, driveRodBearingHoldingT])cube([totalW, motorHeight, topGearSurroundingRingH]);
         translate([-topGearSurroundingHoleD/2-topGearSurroundingRingT, topGearSurroundingRingVertFudge, driveRodBearingHoldingT])cube([topGearSurroundingHoleD+topGearSurroundingRingT*2, topGearSurroundingHoleD/2+topGearSurroundingRingT, topGearSurroundingRingH]);
         hull(){
            translate([0, 0, 0])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = driveRodBearingHoldingT);
            translate([0, topGearSurroundingRingVertFudge, 0])cylinder(d = totalW, h = driveRodBearingHoldingT);
            for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount])translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])cylinder(d = driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), h = driveRodBearingHoldingT);
            translate([-guideIdlerDistOut, -guideIdlerDistBelow, 0])cylinder(d = guideIdlerTAroundRod*2+guideIdlerRodD, h = driveRodBearingHoldingT);
            translate([-totalW/2, motorHeight, 0])cube([totalW, motorPlateT, driveRodBearingHoldingT]);
            translate([structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, 0])cylinder(d = structureBarTAround*2+structureBarD, h = driveRodBearingHoldingT);
            translate([-structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, 0])cylinder(d = structureBarTAround*2+structureBarD, h = driveRodBearingHoldingT);
         }
         translate([-totalW/2, motorHeight, driveRodBearingHoldingT])cube([totalW, motorPlateT, motorTotalD+motorBackwardForward+motorSlack+motorShieldT]);
         
         translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT])cylinder(d = totalW, h = topGearSurroundingRingH);

         translate([-totalW/2, motorHeight-motorTotalL, driveRodBearingHoldingT])cube([totalW, motorTotalL, motorTotalD+motorBackwardForward+motorSlack+motorShieldT]);

      }
      
      translate([structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, -0.001])cylinder(d = structureBarD, h = driveRodBearingHoldingT+0.002);
      translate([-structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, -0.001])cylinder(d = structureBarD, h = driveRodBearingHoldingT+0.002);
      difference(){
         translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT-0.001])cylinder(d = topGearSurroundingHoleD, h = 0.002+topGearSurroundingRingH+motorTotalD);
         translate([-motorSep/2-motorTotalD-motorSlack-motorShieldT, motorHeight-motorTotalL, 0])cube([motorSep+motorTotalD*2+motorSlack*2+motorShieldT*2, motorTotalL, driveRodBearingHoldingT+motorTotalD+motorBackwardForward+motorSlack+motorShieldT]);
      }
      translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT+topGearConeStartH])cylinder(d1 = topGearConeStartSize, d2 = topGearSurroundingHoleD, h = 0.001+topGearSurroundingRingH-topGearConeStartH-topGearConeEndInset);
      translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT])cylinder(d = topGearConeStartSize, h = 0.001+topGearConeStartH);
      translate([0, topGearSurroundingRingVertFudge, driveRodBearingHoldingT+topGearSurroundingRingH-topGearConeEndInset-0.001])cylinder(d = topGearSurroundingHoleD, h = 0.001+motorTotalD);
      
      translate([0, bulletFiringDist, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward-0.001])cylinder(d1 = bulletFiringHoleEndD, d2 = bulletFiringHoleStartD, h = 0.002+max(motorTotalD/2+motorSlack+motorShieldT, topGearSurroundingRingH-motorTotalD/2-motorBackwardForward));
      translate([0, bulletFiringDist, -0.001])cylinder(d = bulletFiringHoleEndD, h = driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward+0.002);
      
      translate([barrelBoltSep, bulletFiringDist, -0.001])Rod(barrelBoltSize, driveRodBearingHoldingT+0.002, ERR = 0.2);
      translate([-barrelBoltSep, bulletFiringDist, -0.001])Rod(barrelBoltSize, driveRodBearingHoldingT+0.002, ERR = 0.2);
      translate([0, motorHeight+motorPlateT-barrelTopBoltIn, 0])Rod(barrelBoltSize, barrelTopBoltL, ERR = 0.2);
      translate([0, motorHeight+motorPlateT-barrelTopBoltIn, barrelTopBoltNutIn])rotate([0, 0, -90])FullNutHole(barrelBoltSize, barrelTopBoltIn, ERR = 0.2, VertERR = 0.5);

      
      translate([-motorTotalD/2-motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([-90, 0, 0])motorBoltHoles(motorPlateT);
      translate([-motorTotalD/2-motorSep/2, motorHeight-3, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([0, -90, 0])cylinder(d = motorWireHoleD, h = totalW);
      translate([-motorTotalD/2-motorSep/2, motorHeight-3, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([-90, 0, 0])cylinder(d = motorBackHoleD, h = motorBackHoleLength);
      translate([motorTotalD/2+motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([-90, 0, 0])motorBoltHoles(motorPlateT);
      translate([motorTotalD/2+motorSep/2, motorHeight-3, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([-90, 0, 0])cylinder(d = motorBackHoleD, h = motorBackHoleLength);
      translate([motorTotalD/2+motorSep/2, motorHeight-3, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([0, 90, 0])cylinder(d = motorWireHoleD, h = totalW);
      translate([-motorTotalD/2-motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([90, 0, 0])cylinder(d = motorSlack*2+motorTotalD, h = motorTotalL+motorSlack+topGearSurroundingHoleD/4);
      translate([motorTotalD/2+motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([90, 0, 0])cylinder(d = motorSlack*2+motorTotalD, h = motorTotalL+motorSlack+topGearSurroundingHoleD/4);
      
      %translate([-motorTotalD/2-motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([90, 0, 0])cylinder(d = motorTotalD, h = motorBodyL);
      %translate([motorTotalD/2+motorSep/2, motorHeight, driveRodBearingHoldingT+motorTotalD/2+motorBackwardForward])rotate([90, 0, 0])cylinder(d = motorTotalD, h = motorBodyL);
      
      translate([0, 0, driveRodBearingHoldingT-driveRodBearingExtraGap+0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2+driveRodBearingExtraGap*2, h = driveRodBearingExtraGap);
      
      translate([0, 0, -0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = driveRodBearingHoldingT+0.002);
      
      translate([-guideIdlerDistOut, -guideIdlerDistBelow, -0.001])cylinder(d = guideIdlerRodD, h = driveRodBearingHoldingT+0.002);
      for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
         translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])mirror([0, 0, 1])BoltNormalWithSurface(driveRodBearingHoldBoltType, driveRodBearingHoldBoltSize, driveRodBearingHoldingT, ERR = 0.2);
      }
   }
   
}
//!rotate([-90, 0, 0])frontFrame();

kickStepperSize = Nema17;
kickStepperLength = 47;
kickStepperShaftLength = 25;
kickStepperPlateT = 5;
kickStepperTAroundBolts = 3;
kickStepperForwardFudge = 12.8;

kickWheelOntoStepperShaft = 10;
kickWheelFootCount = 4;
kickDist = motorTotalD/2+motorShieldT+motorSlack+5;
kickWheelFootOffset = kickDist*1.1+stepperStats(kickStepperSize, stepperShaftD)/2-1;
echo(str("kickWheelFootOffset: ", kickWheelFootOffset));
kickStepperOffsetLR = -15;
kickWheelFootTAroundFoot = 5;
kickWheelHoldingNutInset = 3;
kickWheelH = 8;
kickWheelSmallerH = 6;
kickWheelSmallerD = -5;
kickWheelHoldingSize = M3;
kickWheelFootBoltSize = M3;
kickFootL = 5;
kickFootD = 10;
kickSlack = 1.5;
kickWheelSlack = 1;
rearPlateT = 8;
rearTopGearSurroundingRingH = 30;

structureBarD = 8;
structureBarTAround = 3;
structureBarOutDist = 45;

ang = 360*$t;
module rearFrame(){
   bulletFiringDist = (topGearTopR+(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle))*cos(topGearAngle)+beltT+casingBottomExtraT+bulletD/2+bulletFiringVertFudge;
   totalW = max(topGearSurroundingHoleD+topGearSurroundingRingT*2);

   kickStepperHeight = bulletFiringDist+kickStepperShaftLength+kickFootL+kickSlack+bulletHoleMin/2-kickWheelOntoStepperShaft;
   kickStepperPos = kickStepperForwardFudge+kickDist-kickWheelFootOffset;
   difference(){
      union(){
         translate([0, topGearSurroundingRingVertFudge, rearPlateT])cylinder(d = totalW, h = rearTopGearSurroundingRingH);
         hull(){
            translate([guideIdlerDistOut, -guideIdlerDistBelow, 0])cylinder(d = guideIdlerTAroundRod*2+guideIdlerRodD, h = rearPlateT);
            translate([0, topGearSurroundingRingVertFudge, 0])cylinder(d = totalW, h = rearPlateT);
            translate([0, 0, 0])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+rearPlateT*2, h = rearPlateT);
            for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount])translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])cylinder(d = driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), h = rearPlateT);
            translate([kickStepperOffsetLR-stepperStats(kickStepperSize, stepperWidth)/2-kickStepperTAroundBolts, kickStepperHeight-kickStepperPlateT, 0])cube([stepperStats(kickStepperSize, stepperWidth)+kickStepperTAroundBolts*2, kickStepperPlateT, rearPlateT]);
            translate([structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, 0])cylinder(d = structureBarTAround*2+structureBarD, h = rearPlateT);
            translate([-structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, 0])cylinder(d = structureBarTAround*2+structureBarD, h = rearPlateT);
         }
         translate([kickStepperOffsetLR-stepperStats(kickStepperSize, stepperWidth)/2-kickStepperTAroundBolts, kickStepperHeight-kickStepperPlateT, 0])cube([stepperStats(kickStepperSize, stepperWidth)+kickStepperTAroundBolts*2, kickStepperPlateT, rearPlateT+stepperStats(kickStepperSize, stepperWidth)+kickStepperTAroundBolts+kickStepperPos]);
      }
      translate([structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, -0.001])cylinder(d = structureBarD, h = rearPlateT+0.002);
      translate([-structureBarOutDist, motorHeight+motorPlateT-structureBarTAround-structureBarD/2, -0.001])cylinder(d = structureBarD, h = rearPlateT+0.002);
      translate([kickStepperOffsetLR-stepperStats(kickStepperSize, stepperWidth)/2, kickStepperHeight-kickStepperPlateT, rearPlateT+kickStepperPos])rotate([90, 0, 0])stepperBoltPositionTranslate(kickStepperSize){
         AllenButtonBolt(stepperStats(kickStepperSize, stepperBoltSize), kickStepperPlateT, ERR = 0.2);
      }
      translate([kickStepperOffsetLR-stepperStats(kickStepperSize, stepperWidth)/2, kickStepperHeight, rearPlateT+kickStepperPos])rotate([90, 0, 0])stepper(kickStepperSize, stepperL = kickStepperLength, shaftL = kickStepperShaftLength, orientation = 3, ERR = 0.5);
      translate([kickStepperOffsetLR, kickStepperHeight-kickStepperPlateT, rearPlateT+kickStepperPos+stepperStats(kickStepperSize, stepperWidth)/2])rotate([90, 0, 0])cylinder(r = kickWheelFootOffset+max(kickWheelFootTAroundFoot, kickFootD/2+0.5)+kickWheelSlack, h = kickStepperHeight-totalW/4);
      translate([0, topGearSurroundingRingVertFudge, rearPlateT])cylinder(d = topGearSurroundingHoleD, h = rearTopGearSurroundingRingH+0.001);
      translate([0, 0, rearPlateT-driveRodBearingExtraGap+0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2+driveRodBearingExtraGap*2, h = driveRodBearingExtraGap);
      
      translate([0, 0, -0.001])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = rearPlateT+0.002);
      
      for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
         translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])mirror([0, 0, 1])BoltNormalWithSurface(driveRodBearingHoldBoltType, driveRodBearingHoldBoltSize, rearPlateT, ERR = 0.2);
      }
      translate([guideIdlerDistOut, -guideIdlerDistBelow, -0.001])cylinder(d = guideIdlerRodD, h = rearPlateT+0.002);
      %translate([kickStepperOffsetLR, kickStepperHeight-kickStepperShaftLength-stepperStats(kickStepperSize, stepperCircleT)+kickWheelOntoStepperShaft, rearPlateT+kickStepperPos+stepperStats(kickStepperSize, stepperWidth)/2])rotate([-90, 0, 0])rotate([0, 0, -ang/kickWheelFootCount-15])kickWheel();
      translate([rearHandleOtherBoltOff, -rearHandleOtherBoltDown, 0])Rod(rearHandleOtherBoltSize, rearPlateT, ERR = 0.3);

   }
}
//!kickWheel();


module kickWheel(){
   difference(){
      union(){
         translate([0, 0, kickWheelH-kickWheelSmallerH])cylinder(r = kickWheelFootOffset+kickWheelFootTAroundFoot+kickWheelSmallerD, h = kickWheelSmallerH);  
         cylinder(r2 = kickWheelFootOffset+kickWheelFootTAroundFoot+kickWheelSmallerD, r1 = kickWheelFootOffset+kickWheelFootTAroundFoot, h = kickWheelH-kickWheelSmallerH);      
         for(i = [0:kickWheelFootCount-1])rotate([0, 0, 90+(i+(kickWheelFootCount%2==1?1/4:1/2))*360/kickWheelFootCount])
            translate([0, -kickWheelFootOffset, -kickFootL]){
            cylinder(d = kickFootD, h = kickFootL);
         }
      }
      translate([0, 0, -0.001])cylinder(d = stepperStats(kickStepperSize, stepperShaftD)+0.2, h = kickWheelH+0.002);
      translate([kickWheelHoldingNutInset+stepperStats(kickStepperSize, stepperShaftD)/2, 0, kickWheelH/2])rotate([0, 90, 0])FullNutHole(kickWheelHoldingSize, kickWheelH/2, ERR = 0.1, VertERR = 0.5);
      translate([-kickWheelHoldingNutInset-stepperStats(kickStepperSize, stepperShaftD)/2, 0, kickWheelH/2])rotate([0, 90, 180])FullNutHole(kickWheelHoldingSize, kickWheelH/2, ERR = 0.1, VertERR = 0.5);
      
      translate([0, 0, kickWheelH/2])rotate([0, 90, 0])Rod(kickWheelHoldingSize, kickWheelFootOffset+kickWheelFootTAroundFoot, ERR = 0.2);
      translate([0, 0, kickWheelH/2])rotate([0, 90, 180])Rod(kickWheelHoldingSize, kickWheelFootOffset+kickWheelFootTAroundFoot, ERR = 0.2);
      
   }
}
module kickFoot(){
   difference(){
      cylinder(d = kickFootD, h = kickFootL);
      translate([0, 0, kickFootL])AllenCountersunkBolt(kickWheelFootBoltSize, kickFootL, ERR = 0.5);
   }
}

driveStepperType = Nema17;
driveStepperDist = 120;
driveStepperPlateT = 5;
rearHandleBoltSize = M4;
rearHandleDownDist = 25;
rearHandleTAroundBolt = 6;
rearHandleWideWidth = 38;

rearHandleBoltMiddleSize = 28;

rearHandleHolderT = 5;
rearHandleHolderFrontT = 15;
rearHandleHolderFrontH = 50;
rearHandleBodyHOverHandle = 13;
rearHandleRearBoltDist = 110;
rearHandleRearBoltDown = 13;
rearHandleMiddleChannelW = 8;
rearHandleMiddleChannelDepth = 3;

rearHandleFrontTopBoltDist = 7;
rearHandleFrontTopBoltDown = 18;
rearHandleFrontBottomBoltDist = 8;
rearHandleFrontBottomBoltDown = 40;

rearHandleFireMicroBack = 95;
rearHandleFireMicroTopDown = 3;
rearHandleRevMicroFrontBack = 74;
rearHandleRevMicroDown = 0;
rearHandleRevMicroOut = 8;
rearHandleRevMicroInOutSlack = 2;

microBoltSep = 6.5;
microBoltSize = M2;
microW = 5;
microL = 13;
microH = 6;
microHolderPlateT = 5;
microHolderTAroundBolts = 3;

wireHoleD = 7.5;
wireHoleBack = 90;
wireHoleOffset = 10;

rearHandleHolderPlateT = 5;

rearHandleOtherBoltSize = M4;
rearHandleOtherBoltTAround = 4;
rearHandleOtherBoltOff = 50;
rearHandleOtherBoltDown = 30;

rearHandleBearingType = 608_bearing;
rearHandleBearingTAround = 5;
rearHandleBearingDist = 50;

rearHandleSidePlateH = 41;
rearHandleSidePlateT = 5;
module rearHandle(){
   module microBolts(l){
      AllenBolt(microBoltSize, l+5, ERR = 0.2);
      translate([microBoltSep, 0, 0])AllenBolt(microBoltSize, l+5, ERR = 0.2);
      translate([0, 0, -l])mirror([0, 0, 1])FullNutVertHole(microBoltSize, 5, ERR = 0.2);
      translate([microBoltSep, 0, -l])mirror([0, 0, 1])FullNutVertHole(microBoltSize, 5, ERR = 0.2);
      %translate([microBoltSep/2-microL/2, -microH/2, -microW])cube([microL, microH, microW]);
      translate([microBoltSep/2-microL/2, -microH/2, -microW])cube([microL, microH, microW]);
   }
   fullW = max(stepperStats(driveStepperType, stepperWidth), BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldBoltOffset*2+driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), rearHandleWideWidth+rearHandleHolderT*2);
   difference(){
      union(){
         translate([-fullW/2, 0, -rearHandleDownDist])cube([rearHandleSidePlateT, driveStepperDist, rearHandleSidePlateH]);
         translate([0, rearHandleBearingDist-driveRodBearingHoldingT, 0])rotate([-90, 180, 0])hull(){
            cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
            for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount])translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])cylinder(d = driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD), h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
         }
         difference(){
            union(){
               hull(){
                  translate([0, rearHandleBearingDist-driveRodBearingHoldingT, 0])rotate([-90, 180, 0])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
                  translate([-fullW/2, rearHandleBearingDist-driveRodBearingHoldingT, -rearHandleDownDist])cube([0.001, BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldingT+rearHandleDownDist]);
                  translate([0, rearHandleBearingDist-driveRodBearingHoldingT, -rearHandleDownDist])rotate([-90, 180, 0])cylinder(d = BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldingT*2, h = BearingDimention(driveRodBearingType, bearingThickness)-driveRodBearingCrush+driveRodBearingHoldingT);
               }
               hull(){
                  translate([rearHandleOtherBoltOff, 0, -rearHandleOtherBoltDown])rotate([-90, 0, 0])cylinder(d = M(rearHandleOtherBoltSize, boltD)+rearHandleOtherBoltTAround*2, h = rearHandleHolderPlateT);
                  translate([fullW/2, 0, (BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldBoltOffset*2+driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD)-M(rearHandleOtherBoltSize, boltD)-rearHandleOtherBoltTAround*2)/2])rotate([-90, 0, 0])cylinder(d = M(rearHandleOtherBoltSize, boltD)+rearHandleOtherBoltTAround*2, h = rearHandleHolderPlateT);
                  translate([fullW/2, 0, -rearHandleOtherBoltDown])rotate([-90, 0, 0])cylinder(d = M(rearHandleOtherBoltSize, boltD)+rearHandleOtherBoltTAround*2, h = rearHandleHolderPlateT);
               }
               translate([-rearHandleWideWidth/2-rearHandleHolderT, 0, -rearHandleDownDist-rearHandleBodyHOverHandle])cube([fullW, driveStepperDist, rearHandleHolderT+rearHandleBodyHOverHandle]);
               translate([-rearHandleWideWidth/2-rearHandleHolderT, 0, -rearHandleDownDist-rearHandleHolderFrontH])cube([fullW, rearHandleHolderFrontT, rearHandleHolderFrontH]);
            }
         translate([-rearHandleWideWidth/2, -0.001, -rearHandleDownDist-rearHandleHolderFrontH-0.001])cube([rearHandleWideWidth, driveStepperDist+0.002, rearHandleHolderFrontH]);
         }
         translate([-fullW/2, 0, -rearHandleDownDist])cube([fullW, driveStepperPlateT, (BearingDimention(driveRodBearingType, bearingOuterDiam)+driveRodBearingHoldBoltOffset*2+driveRodBearingTAroundHoldBolt*2+M(driveRodBearingHoldBoltSize, boltD))/2+rearHandleDownDist]);
         
         translate([-fullW/2, driveStepperDist-driveStepperPlateT, -rearHandleDownDist])cube([fullW, driveStepperPlateT, stepperStats(driveStepperType, stepperWidth)/2+rearHandleDownDist]);
         translate([microW/2, rearHandleFireMicroBack-microH/2, -rearHandleFireMicroTopDown-microBoltSep-rearHandleDownDist-microHolderTAroundBolts])cube([microHolderPlateT, microHolderTAroundBolts*2, microHolderTAroundBolts+microBoltSep+rearHandleFireMicroTopDown]);
         hull(){
            translate([rearHandleBoltMiddleSize/2, rearHandleRearBoltDist, -rearHandleDownDist-rearHandleRearBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([rearHandleBoltMiddleSize/2, rearHandleRearBoltDist, -rearHandleDownDist])rotate([0, 90, 0])cylinder(r = 1, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
         }
         hull(){
            translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleRearBoltDist, -rearHandleDownDist-rearHandleRearBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleRearBoltDist, -rearHandleDownDist])rotate([0, 90, 0])cylinder(r = 1, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
         }
         
         hull(){
            translate([rearHandleBoltMiddleSize/2, rearHandleFrontTopBoltDist, -rearHandleDownDist])rotate([0, 90, 0])cylinder(r = 1, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([rearHandleBoltMiddleSize/2, rearHandleFrontTopBoltDist, -rearHandleDownDist-rearHandleFrontTopBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([rearHandleBoltMiddleSize/2, rearHandleFrontBottomBoltDist, -rearHandleDownDist-rearHandleFrontBottomBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
         }
         hull(){
            translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleFrontTopBoltDist, -rearHandleDownDist])rotate([0, 90, 0])cylinder(r = 1, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleFrontTopBoltDist, -rearHandleDownDist-rearHandleFrontTopBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
            translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleFrontBottomBoltDist, -rearHandleDownDist-rearHandleFrontBottomBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW/2+0.001-rearHandleBoltMiddleSize/2);
         }
         //translate([-rearHandleWideWidth/2-rearHandleHolderT-0.001, rearHandleRearBoltDist, -rearHandleDownDist-rearHandleRearBoltDown])rotate([0, 90, 0])cylinder(r = rearHandleTAroundBolt, h = fullW+0.002);
      }
      translate([0, rearHandleBearingDist, 0])rotate([-90, 180, 0]){
         translate([0, 0, 0])BearingType(driveRodBearingType, ERR = 0.2);
         translate([0, 0, -driveRodBearingExtraGap])cylinder(d = casingGearRodD+topGearHolderRodSlack*2+driveRodBearingExtraGap*2, h = BearingDimention(driveRodBearingType, bearingThickness)+driveRodBearingExtraGap);
         translate([0, 0, -driveRodBearingHoldingT])for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
            translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, 0])Rod(driveRodBearingHoldBoltSize, BearingDimention(driveRodBearingType, bearingThickness)+driveRodBearingHoldingT, ERR = 0.2);
            translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, BearingDimention(driveRodBearingType, bearingThickness)/2-driveRodBearingCrush/2-M(driveRodBearingHoldBoltSize, fullNutH)/2-0.25+driveRodBearingHoldingT/2])rotate([0, 0, -90])FullNutHole(driveRodBearingHoldBoltSize, driveRodBearingTAroundHoldBolt+M(driveRodBearingHoldBoltSize, boltD)+fullW, ERR = 0.2, VertERR = 0.5);
         }
      }
      rotate([90, 0, 0])for(i = [0: driveRodBearingHoldBoltCount-1])rotate([0, 0, i*360/driveRodBearingHoldBoltCount]){
         translate([0, BearingDimention(driveRodBearingType, bearingOuterDiam)/2+driveRodBearingHoldBoltOffset, -rearHandleHolderPlateT])mirror([0, 0, 1])BoltNormalWithSurface(driveRodBearingHoldBoltType, driveRodBearingHoldBoltSize, rearHandleHolderPlateT, ERR = 0.2);
      }
      translate([-wireHoleOffset, wireHoleBack, -rearHandleDownDist-0.002])cylinder(d = wireHoleD, h = rearHandleHolderT+0.003);
      translate([0, rearHandleRearBoltDist, -rearHandleDownDist-rearHandleRearBoltDown])rotate([0, 90, 0]){
         translate([0, 0, fullW/2])AllenButtonBolt(rearHandleBoltSize, fullW+0.002, ERR = 0.2);
         translate([0, 0, -rearHandleWideWidth/2-rearHandleHolderT-0.001])FullNut(rearHandleBoltSize, ERR = 0.2);
      }
      translate([0, rearHandleFrontTopBoltDist, -rearHandleDownDist-rearHandleFrontTopBoltDown])rotate([0, 90, 0]){
         translate([0, 0, fullW/2])AllenButtonBolt(rearHandleBoltSize, fullW+0.002, ERR = 0.2);
         translate([0, 0, -rearHandleWideWidth/2-rearHandleHolderT-0.001])FullNut(rearHandleBoltSize, ERR = 0.2);
      }
      translate([0, rearHandleFrontBottomBoltDist, -rearHandleDownDist-rearHandleFrontBottomBoltDown])rotate([0, 90, 0]){
         translate([0, 0, fullW/2])AllenButtonBolt(rearHandleBoltSize, fullW+0.002, ERR = 0.2);
         translate([0, 0, -rearHandleWideWidth/2-rearHandleHolderT-0.001])FullNut(rearHandleBoltSize, ERR = 0.2);
      }
      
      translate([-rearHandleMiddleChannelW/2, -0.001, -rearHandleDownDist-0.002])cube([rearHandleMiddleChannelW, rearHandleFireMicroBack-microHolderTAroundBolts+0.002, rearHandleMiddleChannelDepth+0.001]);

      translate([0, 0, -0.001])rotate([-90, 0, 0])cylinder(d = casingGearRodD+topGearHolderRodSlack*2, h = driveStepperDist+0.002);
      %translate([0, -0.001, 0])rotate([-90, 0, 0])cylinder(d = casingGearRodD, h = driveStepperDist+0.002);
      translate([-stepperStats(driveStepperType, stepperWidth)/2, driveStepperDist, -stepperStats(driveStepperType, stepperWidth)/2])rotate([90, 0, 0])stepper(driveStepperType);
      translate([-stepperStats(driveStepperType, stepperWidth)/2, driveStepperDist-driveStepperPlateT, -stepperStats(driveStepperType, stepperWidth)/2])rotate([90, 0, 0])stepperBoltPositionTranslate(driveStepperType)AllenBolt(stepperStats(driveStepperType, stepperBoltSize), driveStepperPlateT, ERR = 0.2);
      translate([0, 0, -rearHandleDownDist]){
         translate([-microW/2, rearHandleFireMicroBack, -rearHandleFireMicroTopDown-microBoltSep])rotate([0, -90, 0])microBolts(microW+microHolderPlateT);
         translate([-rearHandleRevMicroOut, rearHandleRevMicroFrontBack-microBoltSep, -rearHandleRevMicroDown-microW])rotate([90, 0, 0])rotate([0, 90, -90])microBolts(microW+microHolderPlateT);
      }
      translate([rearHandleOtherBoltOff, 0, -rearHandleOtherBoltDown])rotate([-90, 0, 0])Rod(rearHandleOtherBoltSize, rearHandleHolderPlateT, ERR = 0.3);
   }
}
batteryL = 130;
batteryW = 40;
batteryH = 30;
batteryWireSectionW = 37;
batteryWireHoleD = 10;
batteryWallT = 3;
batteryLRBias = 0;
batteryCaseBoltSize = M3;
batteryCaseTAroundBolts = 4.5;
batteryCaseNutHoleLIn = 3;
batteryCaseDownFromScrews = -5;
batteryCaseRearPlateT = 5;

batteryCaseCapT = 5;
module batteryHolder(){
   difference(){
      union(){
         hull(){
            translate([-batteryWallT, batteryW/2+structureBarOutDist-batteryLRBias, batteryH+batteryWallT/2+batteryCaseDownFromScrews])rotate([0, 90, 0])cylinder(d = structureBarTAround*2+structureBarD, h = batteryCaseRearPlateT);
            translate([-batteryWallT, batteryW/2-structureBarOutDist-batteryLRBias, batteryH+batteryWallT/2+batteryCaseDownFromScrews])rotate([0, 90, 0])cylinder(d = structureBarTAround*2+structureBarD, h = batteryCaseRearPlateT);
            translate([-batteryWallT, -batteryWallT, -batteryWallT])cube([batteryCaseRearPlateT, batteryWallT*2+batteryW, batteryWallT*3+batteryH*2]);
         }
         translate([-batteryWallT, -batteryWallT, -batteryWallT])cube([batteryWallT+batteryL, batteryWallT*2+batteryW, batteryWallT*3+batteryH*2]);
         translate([batteryL-batteryCaseNutHoleLIn*2, batteryW/2, batteryWallT+batteryH*2+batteryCaseTAroundBolts])hull(){
            rotate([0, 90, 0])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseNutHoleLIn*2);
            translate([-batteryCaseTAroundBolts/2, 0, -batteryCaseTAroundBolts*2+batteryWallT])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseTAroundBolts);
         }
         translate([batteryL-batteryCaseNutHoleLIn*2, batteryW/2, -batteryCaseTAroundBolts])hull(){
            rotate([0, 90, 0])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseNutHoleLIn*2);
            translate([-batteryCaseTAroundBolts/2, 0, batteryCaseTAroundBolts-batteryWallT])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseTAroundBolts);
         }
      }
      translate([-batteryWallT-0.001, batteryW/2+structureBarOutDist-batteryLRBias, batteryH+batteryWallT/2+batteryCaseDownFromScrews])rotate([0, 90, 0])cylinder(d = structureBarD, h = batteryCaseRearPlateT+0.002);
      translate([-batteryWallT-0.001, batteryW/2-structureBarOutDist-batteryLRBias, batteryH+batteryWallT/2+batteryCaseDownFromScrews])rotate([0, 90, 0])cylinder(d = structureBarD, h = batteryCaseRearPlateT+0.002);

      
      translate([batteryL-batteryCaseNutHoleLIn-0.25-M(batteryCaseBoltSize, fullNutH)/2, batteryW/2, batteryWallT+batteryH*2+batteryCaseTAroundBolts])rotate([0, 90, 0])FullNutHole(batteryCaseBoltSize, batteryCaseTAroundBolts, ERR = 0.1, VertERR = 0.5);
      translate([batteryL-batteryCaseTAroundBolts*3/2-batteryCaseNutHoleLIn*2, batteryW/2, batteryWallT+batteryH*2+batteryCaseTAroundBolts])rotate([0, 90, 0])Rod(batteryCaseBoltSize, batteryCaseTAroundBolts*3/2+batteryCaseNutHoleLIn*2, ERR = 0.2);
      
      translate([batteryL-batteryCaseNutHoleLIn-0.25-M(batteryCaseBoltSize, fullNutH)/2, batteryW/2, -batteryCaseTAroundBolts])rotate([0, 90, 0])rotate([0, 0, 180])FullNutHole(batteryCaseBoltSize, batteryCaseTAroundBolts, ERR = 0.1, VertERR = 0.5);
      translate([batteryL-batteryCaseTAroundBolts*3/2-batteryCaseNutHoleLIn*2, batteryW/2, -batteryCaseTAroundBolts])rotate([0, 90, 0])Rod(batteryCaseBoltSize, batteryCaseTAroundBolts*3/2+batteryCaseNutHoleLIn*2, ERR = 0.2);
      
      
      cube([batteryL+0.001, batteryW, batteryH]);
      translate([0, 0, batteryWallT+batteryH])cube([batteryL+0.001, batteryW, batteryH]);
      translate([batteryL, -batteryWallT-0.001, batteryH/2])hull(){
         translate([0, 0, -batteryWireHoleD/2])cube([0.001, batteryWallT+0.002, batteryWireHoleD]);
         translate([-batteryWireHoleD/2, 0, 0])rotate([-90, 0, 0])cylinder(d = batteryWireHoleD, h = batteryWallT+0.002);
      }
      translate([batteryL, -batteryWallT-0.001, batteryWallT+batteryH*3/2])hull(){
         translate([0, 0, -batteryWireHoleD/2])cube([0.001, batteryWallT+0.002, batteryWireHoleD]);
         translate([-batteryWireHoleD/2, 0, 0])rotate([-90, 0, 0])cylinder(d = batteryWireHoleD, h = batteryWallT+0.002);
      }
   }
}
!batteryHolderCap();
module batteryHolderCap(){
   difference(){
      hull(){
         translate([0, -batteryWallT, -batteryWallT])cube([batteryCaseCapT, batteryWallT*2+batteryW, batteryWallT*3+batteryH*2]);

         translate([0, batteryW/2, batteryWallT+batteryH*2+batteryCaseTAroundBolts])rotate([0, 90, 0])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseCapT);
         translate([0, batteryW/2, -batteryCaseTAroundBolts])rotate([0, 90, 0])cylinder(d = batteryCaseTAroundBolts*2, h = batteryCaseCapT);
      }
      translate([0, batteryW/2, -batteryCaseTAroundBolts])rotate([0, 90, 0])Rod(batteryCaseBoltSize, batteryCaseCapT, ERR = 0.2);
      translate([0, batteryW/2, batteryWallT+batteryH*2+batteryCaseTAroundBolts])rotate([0, 90, 0])Rod(batteryCaseBoltSize, batteryCaseCapT, ERR = 0.2);

   }

}
module adjustedTopGear(isFront = false){
   outerH = (casingPairHoleL-casingPairHoleTiltL)/2*cos(topGearAngle);
   innerH = outerH-casingPairH*sin(topGearAngle);
   translate([0, -(topGearTopR+(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle))*sin(topGearAngle), -(topGearTopR+(casingPairHoleL-casingPairHoleTiltL)/2*sin(topGearAngle))*cos(topGearAngle)]){
      rotate([90-topGearAngle, 0, 0]){
         translate([0, 0, outerH+topGearSurfaceExtraT-BearingDimention(topGearBigBearing, bearingThickness)/2]){
            topGearHolder();
            topGearHolderBigBearingHolder();
            
               translate([0, 0, BearingDimention(topGearBigBearing, bearingThickness)/2-topGearSurfaceExtraT-topGearOuterH+((topGearSurfaceExtraT+topGearOuterH+topGearOuterH-casingPairH*sin(topGearAngle))/2)])rotate([topGearAngle, 0, 0])translate([0, 0, (BearingDimention(topGearBigBearing, bearingThickness)+topGearHolderBigBearingPlaneT)*cos(topGearAngle)]){
                  translate([0, 0, topGearHolderBearingOffset+BearingDimention(driveRodBearingType, bearingThickness)])if(isFront){
                     rotate([0, 180, 0])translate([0, 0, -driveRodBearingHoldingT])frontFrame();
                  }else{
                     rotate([0, 180, 0])translate([0, 0, -rearPlateT])rearFrame();
                  }
               }
         }
         casingTopGear();
         translate([0, 0, topGearOuterH+topGearSurfaceExtraT+BearingDimention(topGearBigBearing, bearingThickness)/4])casingTopGearBearingHolder();
      }
   }
}
boardTopW = 49;
boardFullW = 55;
boardT = 2;
boardL = 100;
boardHBelow = 10;
boardOff = 50;
boardTAround = 2;
boardBoltInset = 3;
boardBoltSize = M2;
boardEndL = 6;
boardTAroundHoldBolt = 5;
boardHoldBoltPlateT = 5;
boardHoldBoltOff = 5;

boardCoverT = 2;
boardCoverH = 25;



XT60ConnectorL = 16;
XT60ConnectorT = 8;
XT60ConnectorH = 16;
XT60ConnectorWireD = 5;
XT60ConnectorWireSep = 8;
TAroundXT60 = 2;

switchHoleD = 6;
switchSize = 14;
module doubleXT60ConnectorHole(){
   translate([0, 0, -TAroundXT60-XT60ConnectorH])difference(){
      cube([XT60ConnectorT+TAroundXT60*2, XT60ConnectorL*2+TAroundXT60*3, TAroundXT60+XT60ConnectorH]);
      translate([TAroundXT60, TAroundXT60, TAroundXT60])cube([XT60ConnectorT, XT60ConnectorL, XT60ConnectorH+0.001]);
      translate([TAroundXT60, TAroundXT60*2+XT60ConnectorL, TAroundXT60])cube([XT60ConnectorT, XT60ConnectorL, XT60ConnectorH+0.001]);
      translate([TAroundXT60+XT60ConnectorT/2, TAroundXT60+XT60ConnectorL/2-XT60ConnectorWireSep/2, -0.001])cylinder(d = XT60ConnectorWireD, h = TAroundXT60+0.002);
      translate([TAroundXT60+XT60ConnectorT/2, TAroundXT60+XT60ConnectorL/2+XT60ConnectorWireSep/2, -0.001])cylinder(d = XT60ConnectorWireD, h = TAroundXT60+0.002);
      
      translate([TAroundXT60+XT60ConnectorT/2, TAroundXT60*2+XT60ConnectorL*3/2-XT60ConnectorWireSep/2, -0.001])cylinder(d = XT60ConnectorWireD, h = TAroundXT60+0.002);
      translate([TAroundXT60+XT60ConnectorT/2, TAroundXT60*2+XT60ConnectorL*3/2+XT60ConnectorWireSep/2, -0.001])cylinder(d = XT60ConnectorWireD, h = TAroundXT60+0.002);
   }
}
module electronicsCover(){
   difference(){
      union(){
         hull(){
            cube([boardHoldBoltPlateT, boardHBelow+boardT+boardTAround*2, boardTAround*2+boardFullW]);
            translate([0, structureBarTAround+structureBarD/2, -boardHoldBoltOff])rotate([0, 90, 0])cylinder(r = boardTAroundHoldBolt, h = boardHoldBoltPlateT);
            translate([0, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2])rotate([0, 90, 0])cylinder(d = structureBarTAround*2+structureBarD, h = boardHoldBoltPlateT);
         }
         translate([0, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2])rotate([0, 90, 0])cylinder(d = structureBarTAround*2+structureBarD, h = boardTAround+boardL);
         cube([boardTAround+boardL, boardHBelow+boardT+boardTAround*2, boardTAround*2+boardFullW]);
         cube([boardTAround+boardL, structureBarTAround+structureBarD/2+boardCoverH, boardCoverT]);
         cube([boardTAround+boardL, boardCoverT, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2]);
         translate([0, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-boardCoverT])cube([boardTAround+boardL, boardCoverH, boardCoverT]);
         translate([boardHoldBoltPlateT+boardTAround+boardL-boardHoldBoltPlateT-boardCoverT, boardCoverT+0.001, boardTAround*2+boardFullW+XT60ConnectorT+TAroundXT60*2])cube([boardCoverT, structureBarD+structureBarTAround*2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2-boardTAround*2-boardFullW-XT60ConnectorT-TAroundXT60*2]);
         translate([boardHoldBoltPlateT+boardTAround+boardL-boardHoldBoltPlateT-boardCoverT, structureBarD/2+structureBarTAround+0.001, boardTAround*2+boardFullW+XT60ConnectorT+TAroundXT60*2])cube([boardCoverT, boardCoverH, rearHandleOtherBoltDown+motorHeight+motorPlateT-boardTAround*2-boardFullW-XT60ConnectorT-TAroundXT60*2]);
         translate([0, structureBarTAround+structureBarD/2, 0])cube([boardCoverT, boardCoverH, rearHandleOtherBoltDown+motorHeight+motorPlateT]);
         translate([boardTAround+boardL, boardCoverT, boardTAround*2+boardFullW])mirror([0, 0, 1])rotate([0, 90, 0])doubleXT60ConnectorHole();
      }
      translate([boardTAround/2+boardL/2, -0.001, boardTAround*2+boardFullW+switchSize/2])rotate([-90, 0, 0])cylinder(d = switchHoleD, h = boardCoverT+0.002);
      
      translate([boardTAround+boardEndL, boardTAround, boardTAround+boardFullW/2-boardTopW/2])cube([boardL-boardEndL+0.001, boardHBelow+boardT+boardTAround+0.001, boardTopW]);
      translate([boardTAround, boardTAround+boardHBelow, boardTAround])cube([boardL+0.001, boardT, boardFullW]);
      
      translate([boardTAround+boardBoltInset, 0, boardTAround+boardFullW/2])rotate([-90, 0, 0])Rod(boardBoltSize, boardHBelow+boardT+boardTAround*2, ERR = 0.2);
      translate([0, structureBarTAround+structureBarD/2, -boardHoldBoltOff])rotate([0, 90, 0])Rod(rearHandleOtherBoltSize, boardHoldBoltPlateT, ERR = 0.2);
      
      translate([-0.001, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2])rotate([0, 90, 0])cylinder(d = structureBarD, h = boardHoldBoltPlateT+0.002);
      
      translate([boardHoldBoltPlateT, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2])rotate([0, 90, 0])cylinder(d = structureBarTAround*2+structureBarD-boardCoverT*2, h = boardTAround+boardL-boardHoldBoltPlateT-boardCoverT);
      
      translate([boardHoldBoltPlateT+0.001, boardCoverT+0.001, boardTAround*2+boardFullW+0.001])cube([boardTAround+boardL-boardHoldBoltPlateT-boardCoverT-TAroundXT60-XT60ConnectorH, structureBarD+structureBarTAround*2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2-boardTAround*2-boardFullW]);
      translate([boardHoldBoltPlateT+0.001, boardCoverT+0.001, boardTAround*2+boardFullW++XT60ConnectorT+TAroundXT60*2+0.001])cube([boardTAround+boardL-boardHoldBoltPlateT-boardCoverT, structureBarD+structureBarTAround*2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2-boardTAround*2-boardFullW-XT60ConnectorT-TAroundXT60*2]);
      
      translate([boardHoldBoltPlateT, structureBarTAround+structureBarD/2, rearHandleOtherBoltDown+motorHeight+motorPlateT-structureBarTAround-structureBarD/2])cube([boardTAround+boardL-boardHoldBoltPlateT-boardCoverT, boardCoverH, structureBarTAround+structureBarD/2-boardCoverT-0.001]);

   }
}
//!electronicsCover();
//!rotate([0, -90, 0])union(){
//   batteryHolder();
//   //translate([batteryL, 0, 0])batteryHolderCap();
//   
//}
beltMakingFrameT = 2;
beltMakingFrameLength = 5;
beltMakingFrameSlack = 0.5;
beltMakingFrameHoleD = 3;


module beltMakingFrame(){
   difference(){
      union(){
         cube([(beltMakingFrameLength+1)*casingW, beltW+beltMakingFrameT*2+beltMakingFrameSlack, beltT+casingPairH+beltMakingFrameT*2+beltMakingFrameSlack]);
      }
      translate([-0.001, beltMakingFrameT-beltMakingFrameSlack/2, casingPairH+beltMakingFrameT])cube([(beltMakingFrameLength+1)*casingW+0.002, beltW+beltMakingFrameSlack, beltT+beltMakingFrameSlack]);
      translate([-0.001, -0.001, casingPairH+beltMakingFrameT])cube([casingW*5/4, beltW+beltMakingFrameT*2+0.002+beltMakingFrameT*2, beltT+beltMakingFrameT+0.001+beltMakingFrameT*2]);
      translate([-0.001, -0.001, casingPairH+beltMakingFrameT])cube([casingW*5/4, beltW+beltMakingFrameT*2+0.002+beltMakingFrameT*2, beltT+beltMakingFrameT+0.001+beltMakingFrameT*2]);
      
      translate([casingW*3/2, beltMakingFrameT+beltMakingFrameSlack/2, -0.001])for(i = [0:beltMakingFrameLength-1])translate([casingW*i, 0, 0]){
         translate([0, casingBoltOffset, 0])cylinder(d = beltMakingFrameHoleD+beltMakingFrameSlack, h = beltT+casingPairH+beltMakingFrameT*2+beltMakingFrameSlack+0.002);
         translate([0, beltW-casingBoltOffset, 0])cylinder(d = beltMakingFrameHoleD+beltMakingFrameSlack, h = beltT+casingPairH+beltMakingFrameT*2+beltMakingFrameSlack+0.002);
      }
      translate([casingW/2, beltMakingFrameT+beltMakingFrameSlack/2+beltW/2, beltMakingFrameT+0.001])rotate([0, 0, 90])hull(){
         translate([-casingPairHoleL/2-beltMakingFrameSlack/2, -casingPairHoleW/2-beltMakingFrameSlack/2, 0])cube([casingPairHoleL+beltMakingFrameSlack, casingPairHoleW+beltMakingFrameSlack, casingPairH]);
         translate([-casingPairHoleTiltL/2-beltMakingFrameSlack/2, -casingPairHoleTiltW/2-beltMakingFrameSlack/2, casingPairH])cube([casingPairHoleTiltL+beltMakingFrameSlack, casingPairHoleTiltW+beltMakingFrameSlack, 0.002]);
      }
      
   }
}

!beltMakingFrame();

idlerLength = 125;
idlerD = 40;
idlerHoleD = 15;
idlerBearingType = 608_bearing;
module idler(){
   difference(){
      translate([0, 0, 0.001])cylinder(d = idlerD, h = idlerLength-0.002);
      cylinder(d = idlerHoleD, h = idlerLength);
      BearingType(idlerBearingType, ERR = 0.2);
      translate([0, 0, idlerLength])mirror([0, 0, 1])BearingType(idlerBearingType, ERR = 0.2);
   }
   
}
//!kickWheel();
//!rearFrame();

//!rotate([-90, 0, 0])frontFrame();

//difference(){
   union(){
      translate([0, (casingPairHoleL/2-casingPairHoleTiltL/2), casingW/2/tan(180/beltDriveWheelSides)/cos(180/beltDriveWheelSides)])adjustedTopGear();
      translate([0, casingPairHoleL, 0])rotate([180, 180, 0])translate([0, (casingPairHoleL/2-casingPairHoleTiltL/2), casingW/2/tan(180/beltDriveWheelSides)/cos(180/beltDriveWheelSides)])adjustedTopGear(true);
   }
   rotate([0, ang/beltDriveWheelSides, 0])casingBottomGear(true);
//}
%translate([0, -50, 0])rotate([-90, 0, 0])cylinder(d = 8, h = 160);
translate([0, -45, 0])rotate([0, 0, 180])rearHandle();

translate([-17, -47.5, 26.5-batteryCaseDownFromScrews])rotate([0, 0, 270])batteryHolder();


//module firingMechanism(){
//   difference(){
//      union(){
//         cube([80, 40, 10]);
//         translate([30, 40, 0])cube([20, 150, 10]);
//      }
//      #translate([20, 20, 0])rotate([0, 0, 45])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([20, 20, 0])rotate([0, 0, -45])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([20, 20, 0])rotate([0, 0, 135])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([20, 20, 0])rotate([0, 0, -135])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      
//      #translate([60, 20, 0])rotate([0, 0, 45])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([60, 20, 0])rotate([0, 0, -45])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([60, 20, 0])rotate([0, 0, 135])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//      #translate([60, 20, 0])rotate([0, 0, -135])translate([motorBoltSep/2, 0, 0])Rod(motorBoltSize, 10, ERR = 0.2);
//   }
//}

//module firingWheel(){
//   difference(){
//      union(){
//         cylinder(d = motorWheelD, h = motorFiringSectionL);
//      }
//      translate([motorWheelD/4+motorTotalD/4, -motorWheelBoltHolderT, motorFiringSectionL/2])rotate([90, 0, 0])AllenBoltHole(motorWheelBoltSize, motorWheelD/2, motorWheelD/2, ERR = 0.3);
//      
//      translate([-motorWheelD/4-motorTotalD/4, motorWheelBoltHolderT, motorFiringSectionL/2])rotate([-90, 0, 0])AllenBoltHole(motorWheelBoltSize, motorWheelD/2, motorWheelD/2, ERR = 0.3);
//      
//      translate([-motorWheelD/4-motorTotalD/4, -motorWheelBoltHolderT, motorFiringSectionL/2])rotate([90, 90, 0])FullNutVertHole(motorWheelBoltSize, motorWheelD/2, ERR = 0.2);
//      translate([motorWheelD/4+motorTotalD/4, motorWheelBoltHolderT, motorFiringSectionL/2])rotate([-90, 90, 0])FullNutVertHole(motorWheelBoltSize, motorWheelD/2, ERR = 0.2);
//      
//      translate([0, 0, -0.001])cylinder(d = motorTotalD, h = motorFiringSectionL+0.002);
//      translate([-50, -100, -50])cube([100, 100.2, 100]);
//   }
//}
$fn = 100;


//
//firingCrankRodCount = 3;
//firingCrankR = 15;
//firingCrankExtraR = 5;
//firingCrankH = 7;
//firingCrankHoldingSize = M3;
//firingCrankHoldingNutInset = 3;
//firingCrankRodD = 8;
//
//firingCrankRodSize = M3;
//firingMotor = Nema17;
//firingRodW = 7;
//firingRodH = 3;
//firingRodSlack = 2;
//
//
//module firingCrankTest(){
//   difference(){
//      union(){
//         translate([0, -25, 0])cube([60, 100, 5]);
//         translate([0, -25, 0])cube([60, 10, 50]);
//         translate([0, 65, 0])cube([60, 10, 50]);
//         translate([0, -25, 45])cube([60, 100, 5]);
//      }
//      translate([0, 4, 0])stepper(Nema17, ERR = 0.5);
//      translate([0, 4, 5])stepperBoltPositionTranslate(Nema17)BoltNormalWithSurface(allenBolt, M3, 5, ERR = 0.2);
//      translate([38.2, 25.2, 44.9])cylinder(d = 15, h = 6);
//      %translate([38.2, 25.2, 35])cylinder(d = 8, h = 20);
//      translate([38.2, 25.2, 47])BearingType(608_bearing, ERR = 0.5);
//   }
//}
//
//module firingCrank(useRod = true){
//   difference(){
//      union(){
//         cylinder(r = firingCrankR+firingCrankExtraR, h = firingCrankH);
//      }
//      if(useRod){
//         translate([0, 0, -0.001])cylinder(d = stepperStats(firingMotor, stepperShaftD)+0.2, h = firingCrankH+0.002);
//         translate([firingCrankHoldingNutInset+stepperStats(firingMotor, stepperShaftD)/2, 0, firingCrankH/2])rotate([0, 90, 0])FullNutHole(firingCrankHoldingSize, firingCrankH/2, ERR = 0.1, VertERR = 0.5);
//         translate([-firingCrankHoldingNutInset-stepperStats(firingMotor, stepperShaftD)/2, 0, firingCrankH/2])rotate([0, 90, 180])FullNutHole(firingCrankHoldingSize, firingCrankH/2, ERR = 0.1, VertERR = 0.5);
//      } else {
//         translate([0, 0, -0.001])cylinder(d = firingCrankRodD+0.2, h = firingCrankH+0.002);
//         translate([firingCrankHoldingNutInset+firingCrankRodD/2, 0, firingCrankH/2])rotate([0, 90, 0])FullNutHole(firingCrankHoldingSize, firingCrankH/2, ERR = 0.1, VertERR = 0.5);
//         translate([-firingCrankHoldingNutInset-firingCrankRodD/2, 0, firingCrankH/2])rotate([0, 90, 180])FullNutHole(firingCrankHoldingSize, firingCrankH/2, ERR = 0.1, VertERR = 0.5);
//      }
//      
//      translate([0, 0, firingCrankH/2])rotate([0, 90, 0])Rod(firingCrankHoldingSize, firingCrankR+firingCrankExtraR, ERR = 0.2);
//      translate([0, 0, firingCrankH/2])rotate([0, 90, 180])Rod(firingCrankHoldingSize, firingCrankR+firingCrankExtraR, ERR = 0.2);
//      
//      for(i = [0:firingCrankRodCount-1]){
//         rotate([0, 0, 90+(i+(firingCrankRodCount%2==1?1/4:1/2))*360/firingCrankRodCount])translate([0, -firingCrankR, 0])Rod(firingCrankRodSize, firingCrankH, ERR = 0.5);
//      }
//   }
//}
//module firingRod(){
//   length = firingCrankR*sin(180/firingCrankRodCount)*2-firingRodW-firingRodSlack;
//   difference(){
//      hull(){
//         cylinder(d = firingRodW, h = firingRodH);
//         translate([length, 0, 0])cylinder(d = firingRodW, h = firingRodH);
//      }
//      translate([0, 0, firingRodH])AllenCountersunkBolt(firingCrankRodSize, firingRodH, ERR = 0.5);
//      translate([length, 0, 0])mirror([0, 0, 1])AllenCountersunkBolt(firingCrankRodSize, firingRodH, ERR = 0.5);
//   }
//}
//
////firingCrank(false);

//rotate([0, 0, ang])firingCrank(true);
//translate([firingCrankR*sin(180/firingCrankRodCount)*2-firingRodW-firingRodSlack, 0, firingRodH+firingCrankH+1])rotate([0, 0, ang])firingCrank(false);
//for(i = [0:firingCrankRodCount-1]){
//   rotate([0, 0, ang+90+(i+(firingCrankRodCount%2==1?1/4:1/2))*360/firingCrankRodCount])translate([0, -firingCrankR, firingCrankH+0.5])rotate([0, 0, -ang-90-(i+(firingCrankRodCount%2==1?1/4:1/2))*360/firingCrankRodCount])firingRod();
//}
//translate([-21.2, -25.2, -10])firingCrankTest();

echo(1000/casingW);