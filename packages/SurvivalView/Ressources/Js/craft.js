class Craft {
    constructor(selector) {
        this.element = document.getElementById(selector);
        this.inventory = {
            element: document.getElementById("inventory-container"),
            items: []
        };
        this.craft = {
            element: document.getElementById("craft-container"),
            items: []
        };
        this.receipts = {
            element: document.getElementById("receipts-container"),
            items: []
        };

        this.dragging = null;
        this.elementToDrag = null;
        this.dropIntoTarget = null;

        let previousContainer;
        let previousImageDiv;
        let previousImage;
        this.mouseDownHandler = (evt) => {
            evt.preventDefault();
            //on recupere la cible cliquer
            let target = evt.target.parentNode;
            previousContainer = evt.target.parentNode.parentNode;
            previousImageDiv = evt.target.parentNode;
            previousImage = evt.target;
            if (target && target.className === 'item' && this.dragging == null) {
                this.elementToDrag = target;
                this.elementToDrag.style.opacity = 0.5;
                this.dragging = target.cloneNode(true);
                this.dragging.classList.add('item-draggable');
                this.element.appendChild(this.dragging);
            }
        }
        this.mouseUpHandler = (evt) => {
            evt.preventDefault();

            let target = evt.target.parentNode;
            if (target && target.className === 'item' && this.dragging !== null) {
                this.dropIntoTarget = target;
                if (previousImageDiv.id == "weapons")
                    onEquipWeapons(previousImage.id, 3, 999)
            }
            target = evt.target;
            if (target && target.id === 'player-inventory-stuff1' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "helmet") {
                this.dropIntoTarget = target;
            }
        }

        /* this.stuff1.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff1.element.addEventListener('mouseup', this.mouseUpHandler);
        this.stuff2.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff2.element.addEventListener('mouseup', this.mouseUpHandler); */

        setInterval(() => {
            if (this.dragging) {
                if (mouse.targetElement && mouse.targetElement.parentNode.className === 'item') {
                    mouse.targetElement.parentNode.style.background = 'yellow';
                    const highLight = function() {
                        this.style.background = '';
                    };
                    mouse.targetElement.parentNode.onmouseleave = highLight;
                }
                if (mouse.leftClick) {
                    this.dragging.style.left = (mouse.position.x - 24) + 'px';
                    this.dragging.style.top = (mouse.position.y - 24) + 'px';
                }
                if (!mouse.leftClick) {
                    //if(previousContainer.id != target.id)
                    this.elementToDrag.style = null;
                    if (this.dropIntoTarget) {
                        if (this.dropIntoTarget.className != this.elementToDrag.className) {
                            this.dropIntoTarget.appendChild(this.elementToDrag);
                        } else {
                            this.dropIntoTarget.style = null;
                            let refElement = this.dropIntoTarget.cloneNode(true);
                            let ref2Element = this.elementToDrag.cloneNode(true);
                            this.dropIntoTarget.replaceWith(ref2Element);
                            this.elementToDrag.replaceWith(refElement);
                        }
                    }
                    this.element.removeChild(this.dragging);
                    this.dragging = null;
                    this.elementToDrag = null;
                    this.dropIntoTarget = null;
                }
            }
        }, 1000 / 60)
    }

    addItem(type, item) {
        const itemSlot = this[type].items.push(item);
        item.element.setAttribute("item-id", itemSlot);

        this[type].element.appendChild(item.element);
        return this;
    }

    removeItem(itemId) {
        var totalInventoryChild = inventory.stuff.items.concat(inventory.container.items).concat(inventory.slot.items);

        totalInventoryChild.forEach(inventoryItemChild => {
            if (inventoryItemChild.element.getAttribute("item-id") == itemId) {
                inventoryItemChild.element.parentNode.removeChild(inventoryItemChild.element);
            }
        });
        return this;
    }
}