class Craft {
    constructor(selector) {
        this.element = document.getElementById("player-inventory");
        this.inventory = {
            element: document.getElementById("inventory-container"),
            items: []
        };
        this.craft = {
            element: document.getElementById("craft-container"),
            items: []
        };
        this.receipts = {
            element: document.getElementById("receipt-container"),
            current: 0,
            receipt: []
        };
    }

    addItem(idUnique, item) {
        this.inventory.items[idUnique] = item
        item.element.setAttribute("item-id", idUnique);

        this.inventory.element.appendChild(item.element);
        return this;
    }

    removeAllItems() {
        this.inventory.element.innerHTML = ""
        this.inventory.items = []
        return this;
    }

    removeItem(idUnique, item) {
        if(this.inventory.items[idUnique] != null){
            this.inventory.items[idUnique].element.remove()
            this.inventory.items[idUnique] = null
            return true
        } else {
            return false
        }
    }

    addReceipt(idUnique, receipt) {
        this.receipts.receipt[idUnique] = receipt
        this.receipts.element.appendChild(receipt.element);

        return this;
    }

    removeAllReceipt() {
        this.receipts.element.innerHTML = ""
        this.receipts.receipt = []

        return this;
    }
}

class Receipt {
    constructor(craftid, itemid, type, imageId, name, need) {
        const {
            spriteColonnes,
            wspace,
            hspace,
            url
        } = CONFIG[type]

        this.craftid = craftid
        this.itemid = itemid
        this.type = type
        this.imageId = imageId
        this.name = name
        this.need = need

        //info sur la recette
        this.element = newEl('div');
        this.element.id = type.toString();
        this.element.classList.add('item');

        this.image = newEl('div');
        this.image.classList.add('item-image')
        this.image.setAttribute("name", name);

        if(type == "cars"){
            this.element.style.height = "104px";
            this.element.style.width = "128px";
            this.image.style.height = "104px";
            this.image.style.width = "128px";
        }

        this.image.style.backgroundImage = url;
        this.image.id = imageId;
        let y = Math.floor((imageId - 1) / spriteColonnes) * hspace
        let x = ((imageId - 1) % spriteColonnes) * wspace
        this.image.style.backgroundPosition = "-" + x + "px -" + y + "px";

        this.element.appendChild(this.image);

        this.element.addEventListener('click', (event) => {
            event.preventDefault();
            if(type == "cars"){
                document.getElementById("itemcraft").setAttribute('craft-count', 1)
                document.getElementById("bcraft").innerHTML = "Craft x"+1
            }
            document.getElementById("itemcraft").innerHTML = name
            document.getElementById("itemcraft").setAttribute('craft-id', craftid)
            document.getElementById("needing").innerHTML = ""
            need.forEach(element => {
                let needp = newEl('p');
                let craftcount = parseInt(document.getElementById("itemcraft").getAttribute('craft-count'))
                let count = parseInt(element.count)*craftcount
                needp.innerHTML = count+" "+element.name
                document.getElementById("needing").appendChild(needp)
            });
            craftInventory.receipts.current = craftid
        }, false);

        return this;
    }
}