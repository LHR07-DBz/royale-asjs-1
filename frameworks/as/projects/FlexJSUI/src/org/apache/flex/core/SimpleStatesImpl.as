////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.core
{
    import flash.display.DisplayObject;
    
    import mx.states.AddItems;
    import mx.states.SetEventHandler;
    import mx.states.SetProperty;
    import mx.states.State;
    
    import org.apache.flex.core.IParent;
    import org.apache.flex.core.IStatesObject;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.IEventDispatcher;
    import org.apache.flex.events.ValueChangeEvent;
    import org.apache.flex.utils.MXMLDataInterpreter;
	
    /**
     *  The SimpleStatesImpl class implements a minimal set of
     *  view state functionality that is sufficient for most applications.
     *  It only supports AddItems and SetProperty changes at this time.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SimpleStatesImpl extends EventDispatcher implements IStatesImpl, IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SimpleStatesImpl()
		{
			super();
		}
        
        private var _strand:IStrand;
        
        private var sawInitComplete:Boolean;
        
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            IEventDispatcher(_strand).addEventListener("currentStateChange", stateChangeHandler);
            IEventDispatcher(_strand).addEventListener("initComplete", initialStateHandler);
        }
        
        private function initialStateHandler(event:org.apache.flex.events.Event):void
        {
            sawInitComplete = true;
            stateChangeHandler(new ValueChangeEvent("currentStateChange", false, false, null, 
                IStatesObject(_strand).currentState));
        }		
     
        private function stateChangeHandler(event:ValueChangeEvent):void
        {
            if (!sawInitComplete)
                return;
            
            var doc:IStatesObject = _strand as IStatesObject;
            var arr:Array = doc.states;
            for each (var s:State in arr)
            {
                if (s.name == event.oldValue)
                {
                    revert(s);
                    break;
                }
            }
            for each (s in arr)
            {
                if (s.name == event.newValue)
                {
                    apply(s);
                    break;
                }
            }
            doc.dispatchEvent(new Event("stateChangeComplete"));
        }
        
        private function revert(s:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    for each (var item:DisplayObject in ai.items)
                    {
                        var parent:IParent = item.parent as IParent;
                        parent.removeElement(item);
                    }
                    if (parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                        sp.document[sp.target][sp.name] = sp.previousValue;
                    else
                        sp.document[sp.name] = sp.previousValue;
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        seh.document[seh.target].removeEventListener(seh.name, seh.handlerFunction);
                    }
                    else
                    {
                        seh.document.removeEventListener(seh.name, seh.handlerFunction);
                    }
                }
            }
        }
        
        private function apply(s:State):void
        {
            var arr:Array = s.overrides;
            for each (var o:Object in arr)
            {
                if (o is AddItems)
                {
                    var ai:AddItems = AddItems(o);
                    if (ai.items == null)
                    {
                        ai.items = ai.itemsDescriptor.items as Array;
                        if (ai.items == null)
                        {
                            ai.items = 
                                MXMLDataInterpreter.generateMXMLArray(ai.document,
                                    null, ai.itemsDescriptor.descriptor);
                            ai.itemsDescriptor.items = ai.items;
                        }
                    }
                    for each (var item:DisplayObject in ai.items)
                    {
                        var parent:IParent = ai.document as IParent;
                        if (ai.destination != null)
                            parent = parent[ai.destination] as IParent;
                        if (ai.relativeTo != null)
                        {
                            var child:Object = ai.document[ai.relativeTo];
                            parent = child.parent as IParent;
                            var index:int = parent.getElementIndex(child);
                            if (ai.position == "after")
                                index++;
                            parent.addElementAt(item, index);
                        }
                        else
                        {
                            parent.addElement(item);
                        }
                    }
                    if (parent is IContainer)
                        IContainer(parent).childrenAdded();
                }
                else if (o is SetProperty)
                {
                    var sp:SetProperty = SetProperty(o);
                    if (sp.target != null)
                    {
                        sp.previousValue = sp.document[sp.target][sp.name];
                        sp.document[sp.target][sp.name] = sp.value;
                    }
                    else
                    {
                        sp.previousValue = sp.document[sp.name];
                        sp.document[sp.name] = sp.value;                        
                    }
                }
                else if (o is SetEventHandler)
                {
                    var seh:SetEventHandler = SetEventHandler(o);
                    if (seh.target != null)
                    {
                        seh.document[seh.target].addEventListener(seh.name, seh.handlerFunction);
                    }
                    else
                    {
                        seh.document.addEventListener(seh.name, seh.handlerFunction);
                    }
                }
            }            
        }
	}
}