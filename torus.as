settings.outformat="pdf";

settings.prc=false;
settings.render=0;

import graph3;
import math;

size(4cm,0);

triple Perp = (4,4,6);

pen surfPen=white+opacity(0.2);
pen xarcPen=deepblue+0.7bp;
pen yarcPen=deepred+0.7bp;

currentprojection=perspective(Perp);

real R=3;       //Radius of big circle
real a=1;       //Radius of little circle

real distance3D(triple x, triple y) {

    return sqrt( (x.x - y.x)^2 + (x.y - y.y)^2 + (x.z - y.z)^2);  
}

triple fs(pair t) {
  return ((R+a*Cos(t.y))*Cos(t.x),(R+a*Cos(t.y))*Sin(t.x),a*Sin(t.y));
}

triple normalVEctorTorus(pair p) {

  //triple t = fs(p);
  
  real tx = -sin(p.x);
  real ty = cos(p.x);
  real tz = 0;
  /* tangent vector with respect to little circle */
  real sx = cos(p.x)*(-sin(p.y));
  real sy = sin(p.x)*(-sin(p.y));
  real sz = cos(p.y);
  /* normal is cross-product of tangents */
  real nx = ty*sz - tz*sy;
  real ny = tz*sx - tx*sz;
  real nz = tx*sy - ty*sx;
  /* normalize normal */
  real length = sqrt(nx*nx + ny*ny + nz*nz);
  nx /= length;
  ny /= length;
  nz /= length;
  return (nx,ny,nz);
}

triple centerXYNormal(pair t) {

  triple P = (((R)*Cos(t.x)),(R)*Sin(t.x),0);
  triple T = fs(t);
  return (T.x - P.x, T.y - P.y, T.z - P.z);

}

triple centerpoint(pair t) {

  triple P = (((R)*Cos(t.x)),(R)*Sin(t.x),0);
  return P;

}

pair[] findQuarticRoots(triple X) {

  //write("<---- Roots ----->",Perp);
  //write("X = " ,X);
  triple E = X - Perp;
  //write("E = ",E);
  
  //draw((0,0,0) -- E , blue,arrow=Arrow3());
  
  real G = 4 * R^2 * (E.x^2 + E.y^2);
  real H = 8 * R^2 * (Perp.x * E.x + Perp.y * E.y);
  real I = 4 * R^2 * (Perp.x^2 + Perp.y^2);
  real J = E.x^2 + E.y^2 + E.z^2;
  real K = 2 * (Perp.x * E.x + Perp.y * E.y + Perp.z * E.z);
  real L = Perp.x^2 + Perp.y^2 + Perp.z^2 + R^2 - a^2;
  
  return quarticroots(J^2, 2*J*K, 2*J*L+K^2-G, 2*K*L-H, L^2-I);
}

draw(O--6X, black); //x-axis
draw(O--6Y, green); //y-axis
draw(O--6Z, red);  //z-axis

//draw(O--(6,5,6), red);  
 
surface s=surface(fs,(0,0),(360,360),8,8,Spline);
draw(s,surfPen,render(compression=Low,merge=true));

int m=8;
int n=8;
real arcFactor=0.85;

pair p,q,v;

for(int i=1;i<=n;++i){
  for(int j=0;j<m;++j){
    p=(j*360/m,(i%n)*360/n);

    path3 mycircle = circle(c=fs(p), r=0.1,normal=centerXYNormal(p));
    //draw(mycircle, blue);
    //dot(centerpoint(p));
    //draw(fs(p)-- (fs(p)+centerXYNormal(p)) , blue,arrow=Arrow3());

    write("i/j  ", i, j);
    pair[] rts = findQuarticRoots(fs(p));
        

    if ( rts.length > 0 ) {
    
        triple E = fs(p) - Perp;
        triple min = (0,0,0);
        triple current = min;
        for ( int it = 0 ; it < rts.length ; ++it ) {
            
            write("Step - >", it );
            if ( rts[it].y == 0 ) {
                current = (rts[it].x* E.x + Perp.x ,rts[it].x* E.y + Perp.y, rts[it].x* E.z + Perp.z);
                write("crt", current);
                if ( min == (0,0,0) ) {
                    min = current;
                    
                }
                
                if ( distance3D(min,Perp) - distance3D(current,Perp) > 0.0) {
                    
                    min = current;
                }
            }
            write("min",min);
            write("fs ", fs(p));
            write();
            if ( distance3D(min,fs(p)) < 0.005) { 
                draw(mycircle, blue);
            } else {
                draw(mycircle, blue +opacity(0.1));
            }
        }
    }
  }
  
}
