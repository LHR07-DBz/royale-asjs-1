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
package mx.controls.listClasses
{   
COMPILE::JS
{
    import goog.DEBUG;
}

import mx.core.EdgeMetrics;
import mx.core.IFactory;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.mx_internal;

import org.apache.royale.core.ContainerBaseStrandChildren;
import org.apache.royale.core.IBeadLayout;
import org.apache.royale.core.IChild;
import org.apache.royale.core.IContainer;
import org.apache.royale.core.IContainerBaseStrandChildrenHost;
import org.apache.royale.core.IDataProviderItemRendererMapper;
import org.apache.royale.core.IItemRendererClassFactory;
import org.apache.royale.core.ILayoutHost;
import org.apache.royale.core.ILayoutChild;
import org.apache.royale.core.ILayoutParent;
import org.apache.royale.core.ILayoutView;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.utils.loadBeadFromValuesManager;

use namespace mx_internal;

	
/**
 *  Dispatched when the user clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemClick", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user double-clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_DOUBLE_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemDoubleClick", type="mx.events.ListEvent")]
	
    /**
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *  @royalesuppresspublicvarwarning
	*/
	public class ListBase extends UIComponent implements IContainerBaseStrandChildrenHost, IContainer, ILayoutParent, ILayoutView
	{
	
        //----------------------------------
        //  dragEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dragEnabled property.
         */
        private var _dragEnabled:Boolean = false;
        
        /**
         *  A flag that indicates whether you can drag items out of
         *  this control and drop them on other controls.
         *  If <code>true</code>, dragging is enabled for the control.
         *  If the <code>dropEnabled</code> property is also <code>true</code>,
         *  you can drag items and drop them within this control
         *  to reorder the items.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dragEnabled():Boolean
        {
            return _dragEnabled;
        }
        
        /**
         *  @private
         */
        public function set dragEnabled(value:Boolean):void
        {
            _dragEnabled = value;
        }
        
        //----------------------------------
        //  dragMoveEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the dragMoveEnabled property.
         */
        private var _dragMoveEnabled:Boolean = false;
        
        [Inspectable(defaultValue="false")]
        
        /**
         *  A flag that indicates whether items can be moved instead
         *  of just copied from the control as part of a drag-and-drop
         *  operation.
         *  If <code>true</code>, and the <code>dragEnabled</code> property
         *  is <code>true</code>, items can be moved.
         *  Often the data provider cannot or should not have items removed
         *  from it, so a MOVE operation should not be allowed during
         *  drag-and-drop.
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dragMoveEnabled():Boolean
        {
            return _dragMoveEnabled;
        }
        
        /**
         *  @private
         */
        public function set dragMoveEnabled(value:Boolean):void
        {
            _dragMoveEnabled = value;
        }
        
        //----------------------------------
        //  dataProvider
        //----------------------------------
        
        [Bindable("collectionChange")]
        [Inspectable(category="Data", defaultValue="undefined")]
        
        /**
         *  Set of data to be viewed.
         *  This property lets you use most types of objects as data providers.
         *  If you set the <code>dataProvider</code> property to an Array, 
         *  it will be converted to an ArrayCollection. If you set the property to
         *  an XML object, it will be converted into an XMLListCollection with
         *  only one item. If you set the property to an XMLList, it will be 
         *  converted to an XMLListCollection.  
         *  If you set the property to an object that implements the 
         *  IList or ICollectionView interface, the object will be used directly.
         *
         *  <p>As a consequence of the conversions, when you get the 
         *  <code>dataProvider</code> property, it will always be
         *  an ICollectionView, and therefore not necessarily be the type of object
         *  you used to  you set the property.
         *  This behavior is important to understand if you want to modify the data 
         *  in the data provider: changes to the original data may not be detected, 
         *  but changes to the ICollectionView object that you get back from the 
         *  <code>dataProvider</code> property will be detected.</p>
         * 
         *  @default null
         *  @see mx.collections.ICollectionView
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get dataProvider():Object
        {
            return (model as ISelectionModel).dataProvider;
        }
        /**
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set dataProvider(value:Object):void
        {
            (model as ISelectionModel).dataProvider = value;
        }
        
        
        //----------------------------------
        //  dropEnabled
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the <code>dropEnabled</code> property.
         */
        private var _dropEnabled:Boolean = false;
        
        [Inspectable(defaultValue="false")]
        
        /**
         *  A flag that indicates whether dragged items can be dropped onto the 
         *  control.
         *
         *  <p>If you set this property to <code>true</code>,
         *  the control accepts all data formats, and assumes that
         *  the dragged data matches the format of the data in the data provider.
         *  If you want to explicitly check the data format of the data
         *  being dragged, you must handle one or more of the drag events,
         *  such as <code>dragOver</code>, and call the DragEvent's
         *  <code>preventDefault()</code> method to customize
         *  the way the list class accepts dropped data.</p>
         *
         *  <p>When you set <code>dropEnabled</code> to <code>true</code>, 
         *  Flex automatically calls the <code>showDropFeedback()</code> 
         *  and <code>hideDropFeedback()</code> methods to display the drop indicator.</p>
         *
         *  @default false
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get dropEnabled():Boolean
        {
            return _dropEnabled;
        }
        
        /**
         *  @private
         */
        public function set dropEnabled(value:Boolean):void
        {
            _dropEnabled = value;
        }
        
        //----------------------------------
        //  labelField
        //----------------------------------
                
        [Bindable("labelFieldChanged")]
        [Inspectable(category="Data", defaultValue="label")]
        
        /**
         *  The name of the field in the data provider items to display as the label. 
         *  By default the list looks for a property named <code>label</code> 
         *  on each item and displays it.
         *  However, if the data objects do not contain a <code>label</code> 
         *  property, you can set the <code>labelField</code> property to
         *  use a different property in the data object. An example would be 
         *  "FullName" when viewing a set of people names fetched from a database.
         *
         *  @default "label"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function get labelField():String
        {
            return (model as ISelectionModel).labelField;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
         */
        public function set labelField(value:String):void
        {
            (model as ISelectionModel).labelField = value;
        }
        
	//----------------------------------
    //  selectedIndex
    //----------------------------------

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]

    /**
     *  The index in the data provider of the selected item.
     * 
     *  <p>The default value is -1 (no selected item).</p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function get selectedIndex():int
    {
        return (model as ISelectionModel).selectedIndex;
    }

    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    public function set selectedIndex(value:int):void
    {
       // if (!collection || collection.length == 0)
       // {
        (model as ISelectionModel).selectedIndex = value;
         //   bSelectionChanged = true;
         //   bSelectedIndexChanged = true;
          //  invalidateDisplayList();
            return;
       // }
        //commitSelectedIndex(value);
    }
	
    //----------------------------------
    //  selectedIndices
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]
    
    /**
     *  An array of indices in the data provider of the selected items. The
     *  items are in the reverse order that the user selected the items.
     *  @default [ ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndices():Array
    {
        // TODO
        if (GOOG::DEBUG)
            trace("selectedIndices not implemented");
        return null;
    }
    
    /**
     *  @private
     */
    public function set selectedIndices(indices:Array):void
    {
        // TODO
        if (GOOG::DEBUG)
            trace("selectedIndices not implemented");
    }
    
    //----------------------------------
    //  selectedItems
    //----------------------------------
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    
    /**
     *  An array of references to the selected items in the data provider. The
     *  items are in the reverse order that the user selected the items.
     *  @default [ ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedItems():Array
    {
        // TODO
        if (GOOG::DEBUG)
            trace("selectedItems not implemented");
        return null;
    }
    
    /**
     *  @private
     */
    public function set selectedItems(items:Array):void
    {
        // TODO
        if (GOOG::DEBUG)
            trace("selectedItems not implemented");
    }
    
	//----------------------------------
    //  variableRowHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the variableRowHeight property.
     */
    private var _variableRowHeight:Boolean = false;

    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the individual rows can have different
     *  height. This property is ignored by TileList and HorizontalList.
     *  If <code>true</code>, individual rows can have different height values.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get variableRowHeight():Boolean
    {
        return _variableRowHeight;
    }

    /**
     *  @private
     */
    public function set variableRowHeight(value:Boolean):void
    {
        _variableRowHeight = value;
       // itemsSizeChanged = true;

       // invalidateDisplayList();

       // dispatchEvent(new Event("variableRowHeightChanged"));
    }

    //----------------------------------
    //  allowMultipleSelection
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the allowMultipleSelection property.
     */
    private var _allowMultipleSelection:Boolean = false;
    
    [Inspectable(category="General", enumeration="false,true", defaultValue="false")]
    
    /**
     *  A flag that indicates whether you can allow more than one item to be
     *  selected at the same time.
     *  If <code>true</code>, users can select multiple items.
     *  There is no option to disallow discontiguous selection.
     *  Standard complex selection options are always in effect 
     *  (Shift-click, Ctrl-click).
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get allowMultipleSelection():Boolean
    {
        return _allowMultipleSelection;
    }
    
    /**
     *  @private
     */
    public function set allowMultipleSelection(value:Boolean):void
    {
        _allowMultipleSelection = value;
    }

	
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function ListBase()
		{
			super();            
		}
        
        private var _DCinitialized:Boolean = true;
        
        /**
         * @private
         */
        override public function addedToParent():void
        {
            if (!_DCinitialized)
            {
                ValuesManager.valuesImpl.init(this);
                _DCinitialized = true;
            }
            
            super.addedToParent();

            // Load the layout bead if it hasn't already been loaded.
            loadBeadFromValuesManager(IBeadLayout, "iBeadLayout", this);

            // Even though super.addedToParent dispatched "beadsAdded", DataContainer still needs its data mapper
            // and item factory beads. These beads are added after super.addedToParent is called in case substitutions
            // were made; these are just defaults extracted from CSS.
            loadBeadFromValuesManager(IDataProviderItemRendererMapper, "iDataProviderItemRendererMapper", this);
            loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", this);
            
            dispatchEvent(new Event("initComplete"));
        }
        
        /*
        * IItemRendererProvider
        */
        
        private var _itemRenderer:IFactory;
        
        /**
         *  The class or factory used to display each item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get itemRenderer():IFactory
        {
            return _itemRenderer;
        }
        public function set itemRenderer(value:IFactory):void
        {
            _itemRenderer = value;
        }
        
        private var _strandChildren:ContainerBaseStrandChildren;
        
        /**
         * @private
         */
        public function get strandChildren():IParent
        {
            if (_strandChildren == null) {
                _strandChildren = new ContainerBaseStrandChildren(this);
            }
            return _strandChildren;
        }
        
        /**
         *  @private
         */
        public function childrenAdded():void
        {
            dispatchEvent(new ValueEvent("childrenAdded"));
        }
        
        /**
         * Returns the ILayoutHost which is its view. From ILayoutParent.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.ILayoutHost
         */
        public function getLayoutHost():ILayoutHost
        {
            return view as ILayoutHost;
        }
        
        /*
        * The following functions are for the SWF-side only and re-direct element functions
        * to the content area, enabling scrolling and clipping which are provided automatically
        * in the JS-side. GroupBase handles event dispatching if necessary.
        */
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            var contentView:IParent = getLayoutHost().contentView as IParent;
            if (contentView == this)
                return super.addElement(c, dispatchEvent);
            contentView.addElement(c, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            var contentView:IParent = getLayoutHost().contentView as IParent;
            if (contentView == this)
                return super.addElementAt(c, index, dispatchEvent);
            contentView.addElementAt(c, index, dispatchEvent);
            if (dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenAdded", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function getElementIndex(c:IChild):int
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                return super.getElementIndex(c);
            return contentView.getElementIndex(c);
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            contentView.removeElement(c, dispatchEvent);
            //TODO This should possibly be ultimately refactored to be more PAYG
            if(dispatchEvent)
                this.dispatchEvent(new ValueEvent("childrenRemoved", c));
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function get numElements():int
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                return super.numElements;
            return contentView.numElements;
        }
        
        /**
         * @private
         */
        COMPILE::SWF
        override public function getElementAt(index:int):IChild
        {
            var layoutHost:ILayoutHost = view as ILayoutHost;
            var contentView:IParent = layoutHost.contentView as IParent;
            if (contentView == this)
                    return super.getElementAt(index);
            return contentView.getElementAt(index);
        }
        
        /*
        * IStrandPrivate
        *
        * These "internal" function provide a backdoor way for proxy classes to
        * operate directly at strand level. While these function are available on
        * both SWF and JS platforms, they really only have meaning on the SWF-side. 
        * Other subclasses may provide use on the JS-side.
        *
        * @see org.apache.royale.core.IContainer#strandChildren
        */
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $numElements():int
        {
            return super.numElements;
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.addElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            super.addElementAt(c, index, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            super.removeElement(c, dispatchEvent);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementIndex(c:IChild):int
        {
            return super.getElementIndex(c);
        }
        
        /**
         * @private
         * @suppress {undefinedNames}
         * Support strandChildren.
         */
        public function $getElementAt(index:int):IChild
        {
            return super.getElementAt(index);
        }
        
        //----------------------------------
        //  explicitColumnCount
        //----------------------------------
        
        /**
         *  The column count requested by explicitly setting the
         *  <code>columnCount</code> property.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitColumnCount:int = -1;
        
        //----------------------------------
        //  explicitColumnWidth
        //----------------------------------
        
        /**
         *  The column width requested by explicitly setting the 
         *  <code>columnWidth</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitColumnWidth:Number;
        
        //----------------------------------
        //  explicitRowHeight
        //----------------------------------
        
        /**
         *  The row height requested by explicitly setting
         *  <code>rowHeight</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitRowHeight:Number;
        
        //----------------------------------
        //  explicitRowCount
        //----------------------------------
        
        /**
         *  The row count requested by explicitly setting
         *  <code>rowCount</code>.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var explicitRowCount:int = -1;
        
        //----------------------------------
        //  defaultColumnCount
        //----------------------------------
        
        /**
         *  The default number of columns to display.  This value
         *  is used if the calculation for the number of
         *  columns results in a value less than 1 when
         *  trying to calculate the columnCount based on size or
         *  content.
         *
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var defaultColumnCount:int = 4;
        
        //----------------------------------
        //  defaultRowCount
        //----------------------------------
        
        /**
         *  The default number of rows to display.  This value
         *  is used  if the calculation for the number of
         *  columns results in a value less than 1 when
         *  trying to calculate the rowCount based on size or
         *  content.
         *
         *  @default 4
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var defaultRowCount:int = 4;
        
        //----------------------------------
        //  rowHeight
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the rowHeight property.
         */
        private var _rowHeight:Number;
        
        /**
         *  @private
         */
        private var rowHeightChanged:Boolean = false;
        
        [Inspectable(category="General")]
        
        /**
         *  The height of the rows in pixels.
         *  Unless the <code>variableRowHeight</code> property is
         *  <code>true</code>, all rows are the same height.  
         *  If not specified, the row height is based on
         *  the font size and other properties of the renderer.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get rowHeight():Number
        {
            return _rowHeight;
        }
        
        /**
         *  @private
         */
        public function set rowHeight(value:Number):void
        {
            explicitRowHeight = value;
            
            if (_rowHeight != value)
            {
                _rowHeight = value;
                
                /*
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                
                dispatchEvent(new Event("rowHeightChanged"));
                */
            }
        }
        
        //----------------------------------
        //  columnWidth
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the columnWidth property.
         */
        private var _columnWidth:Number;
        
        /**
         *  @private
         */
        private var columnWidthChanged:Boolean = false;
        
        /**
         *  The width of the control's columns.
         *  This property is used by TileList and HorizontalList controls;
         *  It has no effect on DataGrid controls, where you set the individual
         *  DataGridColumn widths.
         *  
         * @default 50
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get columnWidth():Number
        {
            return _columnWidth;
        }
        
        /**
         *  @private
         */
        public function set columnWidth(value:Number):void
        {
            explicitColumnWidth = value;
            
            if (_columnWidth != value)
            {
                _columnWidth = value;
                
                /*
                invalidateSize();
                itemsSizeChanged = true;
                invalidateDisplayList();
                
                dispatchEvent(new Event("columnWidthChanged"));*/
            }
        }
        
        /**
         *  @royaleignorecoercion org.apache.royale.core.ILayoutChild
         */
        override protected function measure():void
        {
            super.measure();
            
            var cc:int = explicitColumnCount < 1 ?
                defaultColumnCount :
                explicitColumnCount;
            
            var rc:int = explicitRowCount < 1 ?
                defaultRowCount :
                explicitRowCount;
            
            if (!isNaN(explicitRowHeight))
            {
                measuredHeight = explicitRowHeight * rc // + o.top + o.bottom;
                //measuredMinHeight = explicitRowHeight * Math.min(rc, 2) +
                //    o.top + o.bottom;
            }
            else
            {
                if (isNaN(rowHeight) && numChildren > 0)
                {
                    rowHeight = (getElementAt(0) as ILayoutChild).height;
                }
                measuredHeight = rowHeight * rc // + o.top + o.bottom;
                //measuredMinHeight = rowHeight * Math.min(rc, 2) +
                //    o.top + o.bottom;
            }
            
            if (!isNaN(explicitColumnWidth))
            {
                measuredWidth = explicitColumnWidth * cc // + o.left + o.right;
                //measuredMinWidth = explicitColumnWidth * Math.min(cc, 1) +
                //    o.left + o.right;
            }
            else
            {
                if (isNaN(columnWidth) && numChildren > 0)
                {
                    columnWidth = (getElementAt(0) as ILayoutChild).width;
                }
                measuredWidth = columnWidth * cc // + o.left + o.right;
                //measuredMinWidth = columnWidth * Math.min(cc, 1) +
                //    o.left + o.right;
            }
        }
    }
}