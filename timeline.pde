/*

Kofocollider interface to SuperCollider written in processing and using OpenObject
Copyright (C) 2015 Krystof Pesek

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

class Timeline{

  float timer;
  float cap = 512;
  float bars;

  Timeline(float _bars){
    timer = 0;
    bars = _bars;
  }

  void update(){


  }

  void render(){

    float div = width / bars;
    stroke(255);
    for(int i = 0; i < bars;i++){
      line(i*div,height-5,i*div,height-10);
    }

    stroke(255,0,0);
    float pos = map(timer,0,cap,0,width);
    line(pos,height-5,pos,height-10);

    timer++;

    /* 
       if(timer%(int)div==0){
       editor.generate();     
       }
     */

    if(timer>=cap)
      timer = 0;


  }


}
