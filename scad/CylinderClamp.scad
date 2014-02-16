

cylinderID=125;
gap=1;
thick = gap+1;
cylinderOD=cylinderID+thick;
cylinderLength=250;

clampZ=40;
clampX=153;
clampY=40;
clampThick=10;
clampBase=10;
supportZ=80;
helixThickness=2;
ledgeHeight=10;
ledgeThickness=7;
tChannelGap=20;
footZ=6;

// From PSSupport.scad
PSx = 111.5;
PSy = 51;
PSz = 203;
PSYOffset=0;


CylinderClamp();
//Foot();

//Tube();
//PSU();



module CylinderClamp()
{
	union()
	{
		difference()
		{
			union()
			{
				difference()
				{
					cube([clampX, clampY, clampZ], center=true);
					EndAngle(ang=57);
					EndAngle(ang=-57);
					translate([0,50,cylinderOD-clampY/2+clampThick])
						rotate([90,0,0])
							Cylinder(rad=cylinderID/2, ht = cylinderLength);
				}
				intersection()
				{
					translate([0,-cylinderOD/2,-clampZ/2+ledgeHeight])
						cube([clampX, clampY+cylinderOD, clampZ/2], center=true);
					Cylinder(rad=cylinderOD/2, ht = 2*cylinderLength);
				}
			}
			translate([0,0,ledgeHeight])
				Cylinder(rad=cylinderOD/2, ht = cylinderLength);
			translate([0,0,-10])
				Cylinder(rad=(cylinderID/2-ledgeThickness), ht = 2*cylinderLength);
			Tube(swell=1);
			PlateScrewHoles();
			FrameClampHoles();
		}
		//Support(ang=48);
		//Support(ang=-48);
	}
}

module Tube(swell = 0)
{
	difference()
	{
		Cylinder(rad=cylinderOD/2, ht = cylinderLength);
		Cylinder(rad=(cylinderID - swell)/2, ht = 2*cylinderLength);
	}
}

module Cylinder(rad=125, ht = 200)
{
	translate([0, -cylinderOD/2+clampY/2-clampThick, 
		cylinderLength/2-clampZ/2+clampBase])
			cylinder(r = rad, h = ht, center=true, $fn=250);
}

module PlateScrewHoles()
{
	translate([0, -cylinderOD/2+clampY/2-clampThick, 0])
	union()
	{
		for(ang=[0:3])
		{
			rotate([0,0,ang*90+45])
			{
				translate([0, cylinderOD/2-ledgeThickness/2-(cylinderOD-cylinderID)/2, 
					0])
				{
					cylinder(r=1.7, h=50, center=true, $fn=20);
					if(ang != 2)
					translate([0, 0, -clampZ/2+1])
						cylinder(r1=3, r2=1.7, h=2, center=true, $fn=20);
				}
				rotate([0,0,45])
				translate([0, cylinderOD/2-ledgeThickness/2-(cylinderOD-cylinderID)/2, 
					0])
				if(ang < 3)
					{
						translate([0, 0, -clampZ/8])
						rotate([90,0,0])
							cylinder(r=1.7, h=50, center=true, $fn=20);
					}
			}
		}
	}
}

module Foot()
{
	intersection()
	{
		difference()
		{
			cube([15,7, footZ], center=true);
			translate([-10, 0, 0])
				rotate([0,-60,0])
					cube([15,10, footZ], center=true);
			translate([10, 0, 0])
				rotate([0,60,0])
					cube([15,10, footZ], center=true);
			cylinder(r=1.7, h=50, center=true, $fn=20);
			translate([0, 0, footZ/2-1])
				cylinder(r2=3, r1=1.7, h=2, center=true, $fn=20);
		}
		translate([0, cylinderOD/2-7/2, 0])
			cylinder(r=cylinderOD/2, h = cylinderLength, center=true, $fn=250);
	}
}

module FrameClampHoles()
{
	union()
	{
		for(x=[-1,1])for(z=[-1,1])
		{
			translate([x*(clampX/2-8), 0, z*tChannelGap/2])
			{
				rotate([90,0,0])
				{
					cylinder(r=2.2,h=2*clampY,center=true,$fn=30);
					translate([0,0,28])
					{
						cylinder(r=4.4,h=2*clampY,center=true,$fn=30);
						translate([0,0,-41.5])
							cylinder(r1=2.2, r2=4.4,h=3,center=true,$fn=30);
					}
				}
			}
		}
	}
}

module Support(ang=50)
{
	difference()
	{
		translate([0, -cylinderOD/2+clampY/2-clampThick, 0])
		rotate([0,0,ang])
		translate([0, cylinderOD/2+clampY/2-1, 
			supportZ/2+clampZ/2-1])
		{
			difference()
			{
				cube([10, clampY, supportZ], center=true);
				translate([0, -clampY + helixThickness+1, -10])
					difference()
					{
						cube([20, clampY, supportZ], center=true);
						translate([0, clampY/2+5, supportZ/2+5])
							rotate([30,0,0])
								cube([30, 20, 20], center=true);
					}
				translate([0, -clampY + 42, -10])
					difference()
					{
						cube([20, clampY-20, supportZ-15], center=true);
						translate([0, clampY-32, supportZ/2-40])
							rotate([12,0,0])
								cube([30, clampY-20, supportZ], center=true);
					}
				translate([0, -clampY/2+4, supportZ/2-4-7/2])
					cube([20, 2, 7], center=true);
				translate([0, clampY/2+8, 0])
					rotate([12,0,0])
						cube([30, clampY, 2*supportZ], center=true);
				//translate([0,clampY/2-12,-supportZ/2+20])
				//	rotate([0,90,0])
				//		cylinder(r=1.7,h=20,center=true,$fn=20);
			}
		}
		Cylinder(rad=cylinderOD/2-gap, ht = cylinderLength);
	}
}

module EndAngle(ang=50)
{
		translate([0, -cylinderOD/2+clampY/2-clampThick, 0])
			rotate([0,0,ang])
		if(ang>0)
		{
			translate([-clampY, cylinderOD/2, 
				0])
					cube([clampY*2, clampY*4, clampZ*2], center=true);
		}else
		{
			translate([clampY, cylinderOD/2, 
				0])
					cube([clampY*2, clampY*4, clampZ*2], center=true);
		}
}

module PSU()
{
	translate([0, -cylinderOD/2+clampY/2-clampThick + PSYOffset, 
		cylinderLength/2-clampZ/2+clampBase])
			cube([PSx, PSy, PSz], center=true);
}