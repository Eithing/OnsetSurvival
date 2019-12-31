class Inventory {
    constructor(selector) {
        this.element = document.getElementById(selector);
        this.subInventory = {
            element: document.getElementById(selector + "-stuff1"),
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
            if (this.elementToDrag === target) {
                return
            }
            if (target && target.className === 'item' && this.dragging !== null) {
                this.dropIntoTarget = target; // C'est cette ligne qui BUG , je sais pas à quoi elle sert
                if (previousImageDiv.id == "weapons" && (target.id === 'player-inventory-slot1' || target.id === 'player-inventory-slot2' || target.id === 'player-inventory-slot3'))
                    ue.game.callevent("onEquipWeapon", JSON.stringify([previousImage.id, 3, 999]));

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
                if (previousImageDiv.id == "weapons")
                    ue.game.callevent("onEquipWeapon", JSON.stringify([1, previousContainer.id.slice(-1), 0]));

            }
            if (target && target.id === 'player-inventory-slot1' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
                ue.game.callevent("onEquipWeapon", JSON.stringify([previousImage.id, 1, 999]));
            }
            if (target && target.id === 'player-inventory-slot2' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
                ue.game.callevent("onEquipWeapon", JSON.stringify([previousImage.id, 2, 999]));
            }
            if (target && target.id === 'player-inventory-slot3' && this.dragging !== null && previousContainer.id != target.id && previousImageDiv.id == "weapons") {
                this.dropIntoTarget = target;
                ue.game.callevent("onEquipWeapon", JSON.stringify([previousImage.id, 3, 999]));
            }
        }

        this.subInventory.element.addEventListener('mousedown', this.mouseDownHandler);
        this.subInventory.element.addEventListener('mouseup', this.mouseUpHandler);

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
                            let dropId = ""
                            let ElementId = ""

                            let keys = ['stuff1', 'stuff2', 'stuff3', 'container', 'slot1', 'slot2', 'slot3']
                            for (const k of keys) {
                                for (const kd of(this.dropIntoTarget.id).split("-")) {
                                    if (k == kd) {
                                        dropId = kd
                                        break
                                    }
                                }
                            }

                            for (const k of keys) {
                                for (const kd of(this.elementToDrag.parentNode.id).split("-")) {
                                    if (k == kd) {
                                        ElementId = kd
                                        break
                                    }
                                }
                            }

                            let Itemidh = this.elementToDrag.getAttribute("item-id")

                            if (ElementId === "slot1") {
                                ue.game.callevent("onEquipWeapon", JSON.stringify([1, 1, 0]));
                            } else if (ElementId === "slot2") {
                                ue.game.callevent("onEquipWeapon", JSON.stringify([1, 2, 0]));
                            } else if (ElementId === "slot3") {
                                ue.game.callevent("onEquipWeapon", JSON.stringify([1, 3, 0]));
                            }

                            inventory[dropId].items[Itemidh] = inventory[ElementId].items[Itemidh]
                            inventory[ElementId].items[Itemidh] = null
                            this.dropIntoTarget.appendChild(this.elementToDrag)
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

    addItem(idUnique, type, item) {
        inventory[type].items[idUnique] = item
        item.element.setAttribute("item-id", idUnique);

        this[type].element.appendChild(item.element);
        return this;
    }

    removeItem(itemId, consume) {
        document.getElementById("infos-image").style.backgroundImage = null;
        document.getElementById("infos-image").style.backgroundPosition = null;
        document.getElementById("infos-title").innerHTML = null;
        document.getElementById("infos-desc").innerHTML = null;
        document.getElementById("item-info").style.visibility = "hidden";
        document.getElementById("infos-use").style.visibility = "hidden";
        let find = false;
        let keys = ['stuff1', 'stuff2', 'stuff3', 'container', 'slot1', 'slot2', 'slot3']
        for (const k of keys) {
            if (inventory[k].items[itemId] != null) {
                inventory[k].items[itemId].element.remove()
                inventory[k].items[itemId] = null
                if (k === "slot1") {
                    ue.game.callevent("onEquipWeapon", JSON.stringify([1, 1, 0]));
                } else if (k === "slot2") {
                    ue.game.callevent("onEquipWeapon", JSON.stringify([1, 2, 0]));
                } else if (k === "slot3") {
                    ue.game.callevent("onEquipWeapon", JSON.stringify([1, 3, 0]));
                }
                if (consume == true) {
                    ue.game.callevent("OnUseItem", JSON.stringify([itemId, inventoryItemChild.element.getAttribute("id")]));
                } else {
                    ue.game.callevent("OnRemoveItem", JSON.stringify([itemId]));
                }
                break
            }
        }
        return this;
    }

    removeAllItems() {
        let keys = ['stuff1', 'stuff2', 'stuff3', 'container', 'slot1', 'slot2', 'slot3']
        for (const k of keys) {
            for (let i = 0; i < inventory[k].items.length; i++) {
                const inventoryItemChild = inventory[k].items[i]
                inventoryItemChild.element.parentNode.removeChild(inventoryItemChild.element);
            }
            inventory[k].items = []
        }
        return this;
    }
}