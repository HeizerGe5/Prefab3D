﻿//Prefab3D. www.closier.nl/prefab .  Fabrice Closier 2013package nl.prefab.guys.types{	import nl.prefab.guys.Guy;	import nl.prefab.guys.data.PropertyData;	import nl.prefab.guys.data.GuysTypes;	import nl.prefab.guys.events.GuyEvent;	 	public class LinearGuy extends Guy	{		public function LinearGuy(id:String){			super(id, GuysTypes.ANIMATION_LINEAR, true);		}  		public override function update():void		{			var property:PropertyData;			var obj:Object;			var j:uint;			var propertyName:String;			var propertyRestored:Boolean;			var sequenceChange:Boolean;			var reverseUpdate:Boolean;						for(var i:uint = 0;i<properties.length;++i){					property = properties[i];					reverseUpdate = false;										if(!property.active) continue;										propertyRestored = property.restored;					sequenceChange = false;										for(j = 0;j<targets.length;++j){												obj = targets[j].object;						if(!obj) continue;						propertyName = property.name;						 						if(!chain && propertyRestored && !isNaN(property.value) ){							obj[propertyName] = property.value;						}												try {														if( (property.playReverse || reverseUpdate ) && !chain){								obj[propertyName] -= property.updateValue;							} else {								obj[propertyName] += property.updateValue;							}													} catch(e:Error){							trace("Property \""+propertyName+"\" not found on this object");							continue;						}												if(property.minValue != Number.MAX_VALUE && obj[propertyName] < property.minValue){														if(chain){								obj[propertyName] = property.minValue;								sequenceChange = true;															} else {																if(property.loop){																		if(property.reverse  || reverseUpdate){										reverseUpdate = true;										property.playReverse = !property.playReverse;										obj[propertyName] = property.minValue;									} else {										obj[propertyName] = property.maxValue;									}																		if(property.playReverse){										dispatchGuyEvent(GuyEvent.REVERSE, property);									} else{										dispatchGuyEvent(GuyEvent.LOOP, property);									}																	} else {									obj[propertyName] = property.minValue;									dispatchGuyEvent(GuyEvent.DONE, property);								}							}						}													if(property.maxValue != Number.MAX_VALUE && obj[propertyName] > property.maxValue){														if(chain){																obj[propertyName] = property.maxValue;								sequenceChange = true;															} else {																if(property.loop){									if(property.reverse || reverseUpdate){										reverseUpdate = true;										property.playReverse = !property.playReverse;										obj[propertyName] = property.maxValue;									} else {										obj[propertyName] = property.minValue;										dispatchGuyEvent(GuyEvent.DONE, property);									}																		if(property.playReverse){										dispatchGuyEvent(GuyEvent.REVERSE, property);									} else{										dispatchGuyEvent(GuyEvent.LOOP, property);									}																		} else {									obj[propertyName] = property.maxValue;									dispatchGuyEvent(GuyEvent.DONE, property);								}								 							}						}					}										if(sequenceChange){						property.active = false;												if(i<properties.length-1){							properties[i+1].active = true;													} else if(chainLoop){							properties[0].active = true;							//restore();						}												dispatchGuyEvent(GuyEvent.SEQUENCE_CHANGE, property);					}										if(propertyRestored)						property.restored = false;			}					}		 		public function addProperty(name:String, startValue:Number, updateValue:Number, loop:Boolean, minValue:Number = NaN, maxValue:Number = NaN, reverse:Boolean = false):PropertyData 		{			var propertyData:PropertyData = new PropertyData(this);			propertyData.name = name;			propertyData.value = startValue;			propertyData.loop = loop;			propertyData.updateValue = updateValue;			propertyData.reverse = reverse;						if(!isNaN(minValue)){				propertyData.minValue = minValue;								if(startValue<minValue)					propertyData.value = minValue;			}							if(!isNaN(maxValue)){				propertyData.maxValue = maxValue;								if(startValue>maxValue)					propertyData.value = minValue;			}						if(!isNaN(minValue) && !isNaN(maxValue)){				if(maxValue<minValue){					propertyData.minValue = maxValue;					propertyData.maxValue = minValue;				}			}						addPropertyData(propertyData);			 			return propertyData;		}			}}