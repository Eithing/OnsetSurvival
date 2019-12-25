class Inventory {
    constructor(selector) {
        this.element = document.getElementById(selector);
        this.stuff1 = {
            element: document.getElementById(selector + "-stuff1"),
            items: []
        };
        this.stuff2 = {
            element: document.getElementById(selector + "-stuff2"),
            items: []
        };
        this.stuff3 = {
            element: document.getElementById(selector + "-stuff3"),
            items: []
        };
        this.stuff4 = {
            element: document.getElementById(selector + "-stuff4"),
            items: []
        };
        this.container = {
            element: document.getElementById(selector + "-container"),
            items: []
        };
        this.slot1 = {
            element: document.getElementById(selector + "-slot1"),
            items: []
        };
        this.slot2 = {
            element: document.getElementById(selector + "-slot2"),
            items: []
        };
        this.slot3 = {
            element: document.getElementById(selector + "-slot3"),
            items: []
        };
        this.dragging = null;
        this.elementToDrag = null;
        this.dropIntoTarget = null;

        let previousContainer;
        let previousImageDiv
        this.mouseDownHandler = (evt) => {
            evt.preventDefault();
            //on recupere la cible cliquer
            let target = evt.target.parentNode;
            previousContainer = evt.target.parentNode.parentNode;
            previousImageDiv = evt.target.parentNode;
            if (target && target.className === 'item' && this.dragging == null) {
                this.elementToDrag = target;
                this.elementToDrag.style.opacity = 0.5;
                this.dragging = target.cloneNode(true);
                this.dragging.classList.add('item-draggable');
                this.element.appendChild(this.dragging);

                //surbrillance des case cibles
                if (previousImageDiv.id == "weapons") {
                    let elements = document.getElementsByClassName("inventory-slot");
                    for (var i = 0; i < elements.length; i++) {
                        elements[i].style.backgroundColor = "rgba(75, 192, 94, 0.25)";
                    }
                }
                if (previousImageDiv.id == "helmet") {
                    document.getElementById("player-inventory-stuff1").style.backgroundColor = "rgba(75, 192, 94, 0.25)";
                }
                if (previousImageDiv.id == "jacket") {
                    document.getElementById("player-inventory-stuff2").style.backgroundColor = "rgba(75, 192, 94, 0.25)";
                }
                if (previousImageDiv.id == "pant") {
                    document.getElementById("player-inventory-stuff3").style.backgroundColor = "rgba(75, 192, 94, 0.25)";
                }
                if (previousImageDiv.id == "shoes") {
                    document.getElementById("player-inventory-stuff4").style.backgroundColor = "rgba(75, 192, 94, 0.25)";
                }
            }
        }
        this.mouseUpHandler = (evt) => {
            evt.preventDefault();

            let target = evt.target.parentNode;
            if (target && target.className === 'item' && this.dragging !== null) {
                this.dropIntoTarget = target;
            }
            target = evt.target;
            if (target && target.id === 'player-inventory-stuff1' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "helmet") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-stuff2' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "jacket") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-stuff3' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "pant") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-stuff4' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "shoes") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-container' && this.dragging !== null && previousContainer.id != target.id) {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-slot1' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-slot2' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
            }
            if (target && target.id === 'player-inventory-slot3' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
            }
        }
        this.stuff1.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff1.element.addEventListener('mouseup', this.mouseUpHandler);
        this.stuff2.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff2.element.addEventListener('mouseup', this.mouseUpHandler);
        this.stuff3.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff3.element.addEventListener('mouseup', this.mouseUpHandler);
        this.stuff4.element.addEventListener('mousedown', this.mouseDownHandler);
        this.stuff4.element.addEventListener('mouseup', this.mouseUpHandler);

        this.container.element.addEventListener('mousedown', this.mouseDownHandler);
        this.container.element.addEventListener('mouseup', this.mouseUpHandler);

        this.slot1.element.addEventListener('mousedown', this.mouseDownHandler);
        this.slot1.element.addEventListener('mouseup', this.mouseUpHandler);
        this.slot2.element.addEventListener('mousedown', this.mouseDownHandler);
        this.slot2.element.addEventListener('mouseup', this.mouseUpHandler);
        this.slot3.element.addEventListener('mousedown', this.mouseDownHandler);
        this.slot3.element.addEventListener('mouseup', this.mouseUpHandler);

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