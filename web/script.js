window.addEventListener('message', (event) => {
    const data = event.data;

    if (data.action === 'open') {
        document.body.style.display = 'flex';

        const content = document.querySelector('.menu-content');
        content.innerHTML = '';

        data.items.forEach((item) => {
            const itemElement = document.createElement('div');
            itemElement.classList.add('menu-item');
            itemElement.innerHTML = `
                <div class="item populated">
                    <img src="nui://${GetParentResourceName()}/web/images/${item.index}.png" alt="${item.nameItem}" class="item-image" />
                    <div class="item-details">
                        <span class="item-name">${item.nameItem}</span>
                    </div>
                    <span class="item-price">Preço: $${item.price}</span>
                    <button class="action-button" onClick="buyItemm('${item.item}')">Pegar</button>
                </div>
            `;        
            content.appendChild(itemElement);
        });
    } else if (data.action === 'close') {
        document.body.style.display = 'none';
    }
});

function buyItemm(item) {
    fetch(`https://${GetParentResourceName()}/buyItem`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({ item })
    })
}

function closeMenu() {
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        }
    })
}


window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeMenu();
    }
})